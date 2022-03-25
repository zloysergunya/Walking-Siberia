import IGListKit
import UIKit

protocol VideosSectionControllerDelegate: AnyObject {
    func videosSectionController(didSelect video: Video)
    func videosSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class VideosSectionController: ListSectionController {
    
    weak var delegate: VideosSectionControllerDelegate?
    
    private var sectionModel: VideoSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
        minimumLineSpacing = 12.0
        
        displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 234.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: VideoCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is VideoSectionModel)
        sectionModel = object as? VideoSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.videosSectionController(didSelect: sectionModel.video)
    }
    
    private func configure(cell: VideoCell) -> UICollectionViewCell {
        ImageLoader.setImage(url: sectionModel.video.preview, imgView: cell.imageView)
        
        cell.nameLabel.text = sectionModel.video.title
        cell.viewsCountLabel.text = R.string.localizable.viewsCount(number: sectionModel.video.countViews, preferredLanguages: ["ru"])
        cell.durationLabel.text = sectionModel.video.duration
        
        return cell
    }
    
}

// MARK: - ListDisplayDelegate
extension VideosSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.videosSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
