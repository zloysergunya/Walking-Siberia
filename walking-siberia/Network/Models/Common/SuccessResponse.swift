import Foundation

struct SuccessResponse<T: Codable>: Codable {
    let success: Bool
    let status: Int
    let data: T?
}
