import Foundation
import SwiftyMenu

struct RouteCity: Codable {
    let id: Int
    var name: String
}

extension RouteCity: SwiftyMenuDisplayable {
    var displayableValue: String { name }
    var retrievableValue: Any { self }
}
