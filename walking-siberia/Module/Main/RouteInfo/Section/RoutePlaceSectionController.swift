import IGListKit

class RoutePlaceSectionController: ListSectionController {
        
    private var sectionModel: RoutePlaceSectionModel!
    
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        
        return numberFormatter
    }()
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 140.0, height: 140.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: RoutePlaceCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    private func configure(cell: RoutePlaceCell) -> UICollectionViewCell {
        ImageLoader.setImage(url: sectionModel.place.photo, imgView: cell.imageView)
        cell.nameLabel.text = sectionModel.place.name
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is RoutePlaceSectionModel)
        sectionModel = object as? RoutePlaceSectionModel
    }
    
}
