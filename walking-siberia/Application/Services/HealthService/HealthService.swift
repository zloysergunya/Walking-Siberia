import UIKit
import HealthKit

protocol HealthServiceInput {
    func requestAccess()
    func getSteps(fromDate: Date, toDate: Date, completion: @escaping (Int, Double) -> Void)
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
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
}

// MARK: - HealthServiceInput
extension HealthService: HealthServiceInput {
    
    func requestAccess() {
        guard HKHealthStore.isHealthDataAvailable() else {
            output?.failureHealthAccessRequest(error: HealthkitSetupError.notAvailableOnDevice)
            
            return
        }
        
        guard let stepCount = stepsCountObject, let distance = distanceObject else {
            output?.failureHealthAccessRequest(error: HealthkitSetupError.dataTypeNotAvailable)
            
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount, distance]
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { [weak self] granted, error in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.output?.failureHealthAccessRequest(error: error)
                } else {
                    self.output?.successHealthAccessRequest(granted: granted)
                }
            }
            
        }
        
    }
    
    func getSteps(fromDate: Date, toDate: Date, completion: @escaping (Int, Double) -> Void) {
        var stepsCount = 0
        var distance = 0.0
        
        guard let stepsQuantityType = stepsCountObject, let distanceQuantityType = distanceObject else {
            completion(stepsCount, distance)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        let startOfDay = Calendar.current.startOfDay(for: fromDate)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay,
                                                    end: toDate,
                                                    options: .strictStartDate)
        
        dispatchGroup.enter()
        let stepsQuery = HKStatisticsQuery(quantityType: stepsQuantityType,
                                           quantitySamplePredicate: predicate,
                                           options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                dispatchGroup.leave()
                return
            }
            
            stepsCount = Int(sum.doubleValue(for: HKUnit.count()))
//            print("!!!stepsCount", stepsCount)
//            
//            let content = UNMutableNotificationContent()
//            content.title = "Изменилось количество шагов"
//            content.body = "Новое значение: \(stepsCount)"
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request)
            
            self.updateUserActivity(stepsCount: stepsCount, distance: distance)
            dispatchGroup.leave()
        }
        healthStore.execute(stepsQuery)
        
        dispatchGroup.enter()
        let distanceQuery = HKStatisticsQuery(quantityType: distanceQuantityType,
                                              quantitySamplePredicate: predicate,
                                              options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                dispatchGroup.leave()
                return
            }
            
            distance = sum.doubleValue(for: HKUnit.meterUnit(with: .kilo))
//            print("!!!distance", distance)
//
//            let content = UNMutableNotificationContent()
//            content.title = "Изменилась дистанция"
//            content.body = "Новое значение: \(distance)"
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request)
            
            self.updateUserActivity(stepsCount: stepsCount, distance: distance)
            dispatchGroup.leave()
        }
        healthStore.execute(distanceQuery)
        
        dispatchGroup.notify(queue: .main) {
            completion(stepsCount, distance)
        }
        
        healthStore.enableBackgroundDelivery(for: stepsQuantityType, frequency: .immediate) { [weak self] success, error in
            if success {
                log.verbose("Steps Background Delivery enabled")
            } else if let error = error {
                self?.output?.failureHealthAccessRequest(error: error)
            }
        }
        
        healthStore.enableBackgroundDelivery(for: distanceQuantityType, frequency: .immediate) { [weak self] success, error in
            if success {
                log.verbose("Distance Background Delivery enabled")
            } else if let error = error {
                self?.output?.failureHealthAccessRequest(error: error)
            }
        }
    }
    
    private func updateUserActivity(stepsCount: Int, distance: Double) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: Date())
        sendUserActivity(walkRequest: WalkRequest(date: dateString, number: stepsCount, km: distance))
    }
    
    private func sendUserActivity(walkRequest: WalkRequest) {
        provider.sendUserActivity(walkRequest: walkRequest) { [weak self] result in
            switch result {
            case .success: UserSettings.lastSendActivityDate = Date()
            case .failure(let error): self?.output?.failureHealthAccessRequest(error: error)
            }
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
