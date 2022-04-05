import Foundation

extension Date {
    
    var endOfDate: Date? {
        return Calendar.current.startOfDay(for: self).add(.day, value: 1)?.add(.second, value: -1)
    }
    
}
