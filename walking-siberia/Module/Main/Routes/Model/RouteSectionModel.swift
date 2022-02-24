import IGListDiffKit

class RouteSectionModel {
    
    var route: Route
    
    init(route: Route) {
        self.route = route
    }
    
}

// MARK: - ListDiffable
extension RouteSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(route.id)" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.route.id == route.id
    }
    
}
