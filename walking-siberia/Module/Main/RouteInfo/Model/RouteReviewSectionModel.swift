import Foundation
import IGListDiffKit

class RouteReviewSectionModel {
    
    let routeReview: RouteReview
    
    init(routeReview: RouteReview) {
        self.routeReview = routeReview
    }
    
}

// MARK: - ListDiffable
extension RouteReviewSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(routeReview.username) \(routeReview.createdAt) \(routeReview.routeId)" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.routeReview == routeReview
    }
    
}
