import IGListDiffKit

class ArticleSectionModel {
    
    let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
}

// MARK: - ListDiffable
extension ArticleSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(article.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.article == article
    }
    
}
