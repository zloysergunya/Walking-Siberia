import Foundation
import IGListDiffKit

class RoutePlaceSectionModel {
    
    let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
}

// MARK: - ListDiffable
extension RoutePlaceSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return place.name as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.place.name == place.name
    }
    
}
