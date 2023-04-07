import IGListKit
import Atributika
import UIKit

protocol TeamsSectionControllerDelegate: AnyObject {
    func teamsSectionController(didSelect team: Team)
    func teamsSectionController(willDisplay cell: UICollectionViewCell, at section: Int)
}

class TeamsSectionController: ListSectionController {
    
    weak var delegate: TeamsSectionControllerDelegate?
    
    private var sectionModel: TeamSectionModel!
    
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
        
        if sectionModel.team == nil {
            return configure(cell: TeamDescriptionCell()).sizeThatFits(collectionContext!.containerSize).inset(by: inset)
        }
        
        return CGSize(width: collectionContext!.containerSize.width, height: 72.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if let team = sectionModel.team {
            let cell = collectionContext!.dequeue(of: TeamCell.self, for: self, at: index)
            return configure(cell: cell, team: team)
        }
        
        let cell = collectionContext!.dequeue(of: TeamDescriptionCell.self, for: self, at: index)
        return configure(cell: cell)
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is TeamSectionModel)
        sectionModel = object as? TeamSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        if let team = sectionModel.team {
            delegate?.teamsSectionController(didSelect: team)
        }
    }
    
    private func configure(cell: TeamDescriptionCell) -> UICollectionViewCell {
        cell.label.text = sectionModel.isDisabled
        ? "Человек с ОВЗ принимает участие в соревнованиях индивидуально."
        : "Команда должна иметь в составе не менее пяти человек, максимальный предел не ограничен."
        
        return cell
    }
    
    private func configure(cell: TeamCell, team: Team) -> UICollectionViewCell {
        cell.nameLabel.text = team.name
        
        if let place = team.place {
            cell.placeLabel.text = "\(place) место"
            cell.placeLabel.isHidden = false
        } else {
            cell.placeLabel.isHidden = true
        }
        
        if let number = team.statistics?.average?.number {
            let bold = Style("bold")
                .font(R.font.geometriaBold(size: 20.0) ?? .systemFont(ofSize: 20.0))
                .foregroundColor(R.color.graphicBlue() ?? .blue)
            
            let text: String
            if number > 30000 {
                text = "<bold>\(number.roundedWithAbbreviations)</bold>\nшаги"
            } else {
                text = "<bold>\(team.statistics?.average?.number ?? 0)</bold>\nшаги"
            }
            
            cell.stepsCountLabel.attributedText = text.style(tags: bold).attributedString
        }

        let side = 48.0
        if team.isDisabled {
            if let url = team.avatar {
                ImageLoader.setImage(url: url, imgView: cell.imageView)
            } else {
                cell.imageView.image = UIImage.createWithBgColorFromText(text: team.name.getInitials(), color: .clear, circular: true, side: 48.0)
                let gradientLayer = GradientHelper.shared.layer(color: .linearRed)
                gradientLayer?.frame = CGRect(side: side)
                cell.gradientLayer = gradientLayer
            }
        } else if team.isClosed {
            cell.imageView.image = R.image.lock48()
            let gradientLayer = GradientHelper.shared.layer(color: .linearRed)
            gradientLayer?.frame = CGRect(side: side)
            cell.gradientLayer = gradientLayer
        } else {
            cell.imageView.image = UIImage.createWithBgColorFromText(text: "\(team.userCount ?? 0)", color: .clear, circular: true, side: 48.0)
            let gradientLayer = GradientHelper.shared.layer(color: .linearBlue)
            gradientLayer?.frame = CGRect(side: side)
            cell.gradientLayer = gradientLayer
        }
        
        cell.contentView.layer.borderWidth = team.isJoined ? 1.0 : 0.0
        
        return cell
    }
    
}

// MARK: - ListDisplayDelegate
extension TeamsSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {}
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        delegate?.teamsSectionController(willDisplay: cell, at: section)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {}
    
}
