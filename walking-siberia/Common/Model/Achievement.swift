import Foundation
import IGListDiffKit

class Achievement: Codable {
    let name: String
    let icon: String
}

// MARK: - ListDiffable
extension Achievement: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return name as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.name == name
    }
    
}
