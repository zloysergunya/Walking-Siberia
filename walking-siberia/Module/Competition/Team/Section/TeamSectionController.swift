import IGListKit
import UIKit

protocol TeamSectionControllerDelegate: AnyObject {
    func teamSectionController(didSelect user: Participant)
    func teamSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class TeamSectionController: ListSectionController {
    
    weak var delegate: TeamSectionControllerDelegate?
    
    private var sectionModel: TeamParticipantSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 0.0)
        minimumLineSpacing = 8.0
        
        displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 72.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: ParticipantCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is TeamParticipantSectionModel)
        sectionModel = object as? TeamParticipantSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.teamSectionController(didSelect: sectionModel.user)
    }
    
    private func configure(cell: ParticipantCell) -> UICollectionViewCell {
        let statistics = sectionModel.user.statistics
        let user = sectionModel.user.user
        let team = sectionModel.team
        
        let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
        cell.nameLabel.text = fullName
        
        if let totalNumber = statistics?.total.number, totalNumber > 0 {
            var text = R.string.localizable.stepsCount(number: totalNumber,
                                                       preferredLanguages: ["ru"])
            if user.dailyStats.number > 30000 {
                text = text.replacingOccurrences(of: "\(totalNumber)",
                                                 with: totalNumber.roundedWithAbbreviations)
            }
            cell.stepsCountLabel.text = text
        }
        
        if let km = statistics?.total.km, km > 0 {
            cell.distanceLabel.text = "\(km) км"
        }
        
        if let url = user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: cell.imageView)
        } else {
            let side = 48.0
            cell.imageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(),
                                                                     color: .clear,
                                                                     circular: true,
                                                                     side: side)
            let gradientLayer = GradientHelper.shared.layer(userId: user.userId)
            gradientLayer?.frame = CGRect(side: side)
            cell.gradientLayer = gradientLayer
        }
        
        cell.contentView.layer.borderWidth = team.ownerId == user.userId ? 1.0 : 0.0
                
        return cell
    }
    
}

// MARK: - ListDisplayDelegate
extension TeamSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.teamSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
