import IGListKit

class RouteReviewSectionController: ListSectionController {
        
    private var sectionModel: RouteReviewSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 214.0, height: 136.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: RouteReviewCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    private func configure(cell: RouteReviewCell) -> UICollectionViewCell {
        cell.nameLabel.text = sectionModel.routeReview.username
        cell.textLabel.text = sectionModel.routeReview.text
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is RouteReviewSectionModel)
        sectionModel = object as? RouteReviewSectionModel
    }
    
}
