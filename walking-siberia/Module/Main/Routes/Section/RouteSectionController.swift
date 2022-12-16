import Foundation
import UIKit
import IGListKit

protocol RouteSectionControllerDelegate: AnyObject {
    func routeSectionController(_ sectionController: RouteSectionController, didSelect sectionModel: RouteSectionModel)
}

class RouteSectionController: ListSectionController {
    
    private var sectionModel: RouteSectionModel!
    
    weak var delegate: RouteSectionControllerDelegate?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 94.0).inset(by: inset)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: RouteCell.self, for: self, at: index)
        
        return configure(cell: cell, for: index)
    }
    
    private func configure(cell: RouteCell, for index: Int) -> UICollectionViewCell {
        ImageLoader.setImage(url: sectionModel.route.photos.first, imgView: cell.imageView)
        
        cell.titleLabel.text = sectionModel.route.name
        cell.distanceLabel.text = "Дистанция: \(sectionModel.route.km) км"
        
        cell.likeButton.setTitle("\(sectionModel.route.countLikes)", for: .normal)
        cell.likeButton.isSelected = sectionModel.route.isLike
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is RouteSectionModel)
        sectionModel = object as? RouteSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.routeSectionController(self, didSelect: sectionModel)
    }
    
}
