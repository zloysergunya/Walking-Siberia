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
    
    private let healthStore = HKHealthStore()
    private let stepsCountObject = HKObjectType.quantityType(forIdentifier: .stepCount)
    private let distanceObject = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
    
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
        
        dispatchGroup.notify(queue: .main) {
            completion(stepsCount, distance)
        }
    }
    
}
