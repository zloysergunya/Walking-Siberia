import UIKit
import HealthKit

protocol HealthServiceInput {
    func requestAccess()
    func getUserActivity(date: Date, completion: ((Int, Double) -> Void)?)
}

protocol HealthServiceOutput: AnyObject {
    func successHealthAccessRequest(granted: Bool)
    func failureHealthAccessRequest(error: Error)
}

enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

class HealthService: NSObject {
    
    weak var output: HealthServiceOutput?
    
    private let provider = HealthServiceProvider()
    private let healthStore = HKHealthStore()
    private let stepsCountObject = HKObjectType.quantityType(forIdentifier: .stepCount)
    private let distanceObject = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
    private let caloriesObject = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
    
    private var authService: AuthService? = ServiceLocator.getService()
    
    override init() {
        super.init()
                
        if let stepsQuantityType = stepsCountObject,
           let distanceQuantityType = distanceObject,
           let caloriesObjectType = caloriesObject {
            setupBackgroundDeliveryFor(types: [stepsQuantityType, distanceQuantityType, caloriesObjectType])
        }
    }
    
    private func setupBackgroundDeliveryFor(types: [HKObjectType]) {
        for type in types {
            guard let sampleType = type as? HKSampleType else {
                log.error("\(type) is not an HKSampleType")
                continue
            }
            
            let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { [weak self] _, completionHandler,_ in
                self?.getUserActivity(date: Date(), completion: nil)
                completionHandler()
            }
            
            healthStore.execute(query)
            healthStore.enableBackgroundDelivery(for: type, frequency: .immediate) { [weak self] success, error in
                if success {
                    log.verbose("\(type) Delivery enabled")
                } else if let error = error {
                    log.error("EnableBackgroundDelivery for type \(type) error: \(error.localizedDescription)")
                    self?.output?.failureHealthAccessRequest(error: ModelError(text: "EnableBackgroundDelivery for type \(type) error: \(error.localizedDescription)"))
                }
            }
        }
    }
    
    private func updateUserActivity(date: Date, stepsCount: Int, distance: Double, calories: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        let walkRequest = WalkRequest(date: dateString,
                                      number: stepsCount,
                                      km: distance,
                                      calories: calories)
        sendUserActivity(walkRequest: walkRequest)
    }
    
    private func sendUserActivity(walkRequest: WalkRequest) {
        guard authService?.authStatus == .authorized else {
            return
        }
        
        provider.sendUserActivity(walkRequest: walkRequest) { [weak self] result in
            switch result {
            case .success:
                UserSettings.lastSendActivityDate = Date()
                log.info("\(walkRequest.date) \(walkRequest.number) \(walkRequest.km)")
                
            case .failure(let error):
                if case .error(let status, _, let err) = error.err,
                   error._code != NSURLErrorTimedOut,
                   ![500, 503].contains(status) {
                    self?.output?.failureHealthAccessRequest(error: error)
                }
            }
        }
    }
    
    private func executeStatisticsQuery(
        quantityType: HKQuantityType,
        predicate: NSPredicate,
        unit: HKUnit,
        completion: @escaping(Double?) -> Void
    ) {
        let query = HKStatisticsQuery(quantityType: quantityType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            
            completion(sum.doubleValue(for: unit))
        }
        healthStore.execute(query)
    }
    
}

// MARK: - HealthServiceInput
extension HealthService: HealthServiceInput {
    
    func requestAccess() {
        guard HKHealthStore.isHealthDataAvailable() else {
            log.error(log.error("NotAvailableOnDevice error: \(HealthkitSetupError.dataTypeNotAvailable)"))
            output?.failureHealthAccessRequest(error: ModelError(text: "Данные Apple Health недоступны на вашем устройстве"))
            
            return
        }
        
        guard let stepCount = stepsCountObject,
              let distance = distanceObject,
              let calories = caloriesObject
        else {
            log.error("DataTypeNotAvailable error: \(HealthkitSetupError.dataTypeNotAvailable)")
            output?.failureHealthAccessRequest(error: ModelError(text: "Разрешите доступ к данным в приложении Здоровья\nЗдоровье -> Доступ -> Приложения -> Сибирь Шагающая -> Разрешить все"))
            
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount, distance, calories]
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { [weak self] granted, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    log.error("RequestAuthorization error: \(error.localizedDescription)")
                    self.output?.failureHealthAccessRequest(error: ModelError(text: "Ошибка авторизации. Проверьте разрешения в приложении Здоровья\nЗдоровье -> Доступ -> Приложения -> Сибирь Шагающая -> Разрешить все"))
                } else {
                    self.output?.successHealthAccessRequest(granted: granted)
                }
            }
        }
        
    }
    
    func getUserActivity(date: Date, completion: ((Int, Double) -> Void)?) {
        var stepsCount = 0
        var distance = 0.0
        var calories = 0
        
        guard let stepsQuantityType = stepsCountObject,
              let distanceQuantityType = distanceObject,
              let caloriesObjectType = caloriesObject
        else {
            completion?(stepsCount, distance)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let predicate = HKObserverQuery.predicateForSamples(withStart: startOfDay,
                                                            end: date.endOfDate ?? date,
                                                            options: .strictStartDate)
        let metaDataPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicate, metaDataPredicate])
        
        dispatchGroup.enter()
        executeStatisticsQuery(quantityType: stepsQuantityType, predicate: compoundPredicate, unit: HKUnit.count()) { value in
            stepsCount = Int(value ?? 0.0)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        executeStatisticsQuery(quantityType: distanceQuantityType, predicate: compoundPredicate, unit: HKUnit.meterUnit(with: .kilo)) { value in
            distance = value ?? 0.0
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        executeStatisticsQuery(quantityType: caloriesObjectType, predicate: compoundPredicate, unit: HKUnit.kilocalorie()) { value in
            calories = Int(value ?? 0.0)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.updateUserActivity(date: date,
                                     stepsCount: stepsCount,
                                     distance: distance,
                                     calories: calories)
            completion?(stepsCount, distance)
        }
    }
    
}

extension HealthService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
