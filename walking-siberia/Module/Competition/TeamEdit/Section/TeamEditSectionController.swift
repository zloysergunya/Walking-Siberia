import IGListKit
import UIKit

protocol TeamEditSectionControllerDelegate: AnyObject {
    func teamEditSectionController(didSelect user: Participant)
    func teamEditSectionController(didChange teamName: String)
    func teamEditSectionController(didChange isTeamClosed: Bool)
    func teamEditSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class TeamEditSectionController: ListSectionController {
    
    weak var delegate: TeamEditSectionControllerDelegate?
    
    private var sectionModel: TeamEditSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 8.0, right: 0.0)
        minimumLineSpacing = 8.0
        
        displayDelegate = self
        supplementaryViewSource = self
    }
    
    override func numberOfItems() -> Int {
        return sectionModel.users.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        
        return CGSize(width: collectionContext!.containerSize.width, height: 72.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: ParticipantCell.self, for: self, at: index)
        
        return configure(cell: cell, participant: sectionModel.users[index])
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is TeamEditSectionModel)
        sectionModel = object as? TeamEditSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.teamEditSectionController(didSelect: sectionModel.users[index])
    }
    
    private func configure(cell: ParticipantCell, participant: Participant) -> UICollectionViewCell {
        let user = participant.user
        
        let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
        cell.nameLabel.text = fullName
        
        var text = R.string.localizable.stepsCount(number: participant.statistics.total.number,
                                                   preferredLanguages: ["ru"])
        if participant.statistics.total.number > 30000 {
            text = text.replacingOccurrences(of: "\(participant.statistics.total.number)",
                                             with: participant.statistics.total.number.roundedWithAbbreviations)
        }
        cell.stepsCountLabel.text = text
        cell.distanceLabel.text = "\(participant.statistics.total.km) км"
        
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
        
        if sectionModel.team?.ownerId == user.userId {
            cell.contentView.layer.borderWidth = 1.0
        }
                
        return cell
    }
    
    @objc private func changeTeamName(_ textField: UITextField) {
        delegate?.teamEditSectionController(didChange: textField.text ?? ")
    }
    
    @objc private func toggleIsTeamClosed(_ sender: UISwitch) {
        delegate?.teamEditSectionController(didChange: sender.isOn)
    }
    
}

// MARK: - ListSupplementaryViewSource
extension TeamEditSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let view = collectionContext!.dequeue(ofKind: UICollectionView.elementKindSectionHeader, for: self, of: TeamEditHeaderView.self, at: index)
        view.nameField.text = sectionModel.team?.name
        view.nameField.addTarget(self, action: #selector(changeTeamName), for: .editingChanged)
        
        view.closeTeamView.switcherView.isOn = sectionModel.team?.isClosed ?? false
        view.closeTeamView.switcherView.addTarget(self, action: #selector(toggleIsTeamClosed), for: .valueChanged)
        
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 184.0)
    }
    
}

// MARK: - ListDisplayDelegate
extension TeamEditSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.teamEditSectionController(willDisplay: cell, at: index)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
