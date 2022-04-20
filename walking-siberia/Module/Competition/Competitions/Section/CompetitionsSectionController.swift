import IGListKit

protocol CompetitionsSectionControllerDelegate: AnyObject {
    func competitionsSectionController(didSelect competition: Competition)
}

class CompetitionsSectionController: ListSectionController {
        
    private var sectionModel: CompetitionSectionModel!
    
    weak var delegate: CompetitionsSectionControllerDelegate?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 12.0, right: 0.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        return CGSize(width: collectionContext!.containerSize.width, height: 78.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: CompetitionCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    private func configure(cell: CompetitionCell) -> UICollectionViewCell {
        cell.nameLabel.text = sectionModel.competition.name
        cell.teamsLabel.text = "Команды: \(sectionModel.competition.countTeams)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let fromDate = dateFormatter.date(from: sectionModel.competition.fromDate) ?? Date()
        let toDate = dateFormatter.date(from: sectionModel.competition.toDate) ?? Date()
        
        dateFormatter.dateFormat = "dd.MM.yyy HH:mm"
        let fromDateString = dateFormatter.string(from: fromDate)
        let toDateString = dateFormatter.string(from: toDate)
        cell.datesLabel.text = "\(fromDateString)-\(toDateString)"
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is CompetitionSectionModel)
        sectionModel = object as? CompetitionSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        delegate?.competitionsSectionController(didSelect: sectionModel.competition)
    }
    
}
