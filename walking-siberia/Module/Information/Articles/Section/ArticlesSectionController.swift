import IGListKit
import UIKit

protocol ArticlesSectionControllerDelegate: AnyObject {
    func articlesSectionController(didSelect article: Article)
    func articlesSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class ArticlesSectionController: ListSectionController {
    
    weak var delegate: ArticlesSectionControllerDelegate?
    
    private var sectionModel: ArticleSectionModel!
    
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
        let cell = collectionContext!.dequeue(of: ArticleCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is ArticleSectionModel)
        sectionModel = object as? ArticleSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.articlesSectionController(didSelect: sectionModel.article)
    }
    
    private func configure(cell: ArticleCell) -> UICollectionViewCell {
        ImageLoader.setImage(url: sectionModel.article.image, imgView: cell.imageView)
        cell.nameLabel.text = sectionModel.article.title
        cell.viewsCountLabel.text = "\(sectionModel.article.countViews) просмотра"
        
        return cell
    }
    
}

// MARK: - ListDisplayDelegate
extension ArticlesSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.articlesSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
