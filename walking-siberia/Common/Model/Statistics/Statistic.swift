import Foundation

struct Statistic: Codable {
    let day, week, month, year: [Day]
    let total: Total
}

struct Total: Codable {
    let number: Int
    let km: Double
}
