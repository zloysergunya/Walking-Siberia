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
    
    private var authService: AuthService? = ServiceLocator.getService()
    
    override init() {
        super.init()
                
        if let stepsQuantityType = stepsCountObject, let distanceQuantityType = distanceObject {
            setupBackgroundDeliveryFor(types: [stepsQuantityType, distanceQuantityType])
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
    
    private func updateUserActivity(date: Date, stepsCount: Int, distance: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        sendUserActivity(walkRequest: WalkRequest(date: dateString, number: stepsCount, km: distance))
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
    
}

// MARK: - HealthServiceInput
extension HealthService: HealthServiceInput {
    
    func requestAccess() {
        guard HKHealthStore.isHealthDataAvailable() else {
            log.error(log.error("NotAvailableOnDevice error: \(HealthkitSetupError.dataTypeNotAvailable)"))
            output?.failureHealthAccessRequest(error: ModelError(text: "Данные Apple Health недоступны на вашем устройстве"))
            
            return
        }
        
        guard let stepCount = stepsCountObject, let distance = distanceObject else {
            log.error("DataTypeNotAvailable error: \(HealthkitSetupError.dataTypeNotAvailable)")
            output?.failureHealthAccessRequest(error: ModelError(text: "Разрешите доступ к данным в приложении Здоровья\nЗдоровье -> Доступ -> Приложения -> Сибирь Шагающая -> Разрешить все"))
            
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount, distance]
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { [weak self] granted, error in
            guard let self = self else {
                return
            }
            
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
        
        guard let stepsQuantityType = stepsCountObject, let distanceQuantityType = distanceObject else {
            completion?(stepsCount, distance)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let predicate = HKObserverQuery.predicateForSamples(withStart: startOfDay,
                                                            end: date.endOfDate ?? date,
                                                            options: .strictStartDate)
        
        dispatchGroup.enter()
        let stepsQuery = HKStatisticsQuery(quantityType: stepsQuantityType,
                                           quantitySamplePredicate: predicate,
                                           options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                dispatchGroup.leave()
                return
            }
            
            stepsCount = Int(sum.doubleValue(for: HKUnit.count()))
            
            dispatchGroup.leave()
        }
        healthStore.execute(stepsQuery)
        
        dispatchGroup.enter()
        let distanceQuery = HKStatisticsQuery(quantityType: distanceQuantityType,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                dispatchGroup.leave()
                return
            }
            
            distance = sum.doubleValue(for: HKUnit.meterUnit(with: .kilo))
            
            dispatchGroup.leave()
        }
        healthStore.execute(distanceQuery)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.updateUserActivity(date: date, stepsCount: stepsCount, distance: distance)
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
