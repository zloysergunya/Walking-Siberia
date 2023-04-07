import IGListKit

final class ProfileAchievementsSectionController: ListSectionController {
        
    private var sectionModel: Achievement!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 88.0, height: 120.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: ProfileAchievementCell.self, for: self, at: index)
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is Achievement)
        sectionModel = object as? Achievement
    }

    private func configure(cell: ProfileAchievementCell) -> UICollectionViewCell {
        cell.nameLabel.text = sectionModel.name
        ImageLoader.setImage(url: sectionModel.icon, imgView: cell.imageView)
        
        return cell
    }
}
