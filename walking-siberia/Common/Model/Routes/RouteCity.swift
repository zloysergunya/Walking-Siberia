import Foundation
import SwiftyMenu

struct RouteCity: Codable {
    let id: Int
    let name: String
}

extension RouteCity: SwiftyMenuDisplayable {
    var displayableValue: String { name }
    var retrievableValue: Any { id }
}
