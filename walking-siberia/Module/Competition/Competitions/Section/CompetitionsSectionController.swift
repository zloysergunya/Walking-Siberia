import IGListKit

class CompetitionsSectionController: ListSectionController {
        
    private var sectionModel: CompetitionSectionModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 78.0).inset(by: inset)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: CompetitionCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    private func configure(cell: CompetitionCell) -> UICollectionViewCell {
        cell.nameLabel.text = sectionModel.competition.name
        cell.teamsLabel.text = "Команды: \(sectionModel.competition.teams.count)"
        cell.datesLabel.text = "\(sectionModel.competition.fromDate)-\(sectionModel.competition.toDate)"
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is CompetitionSectionModel)
        sectionModel = object as? CompetitionSectionModel
    }
    
    override func didSelectItem(at index: Int) {
        super.didSelectItem(at: index)
        
        
    }
    
}
