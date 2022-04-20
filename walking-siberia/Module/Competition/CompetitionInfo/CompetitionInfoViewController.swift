import UIKit

class CompetitionInfoViewController: ViewController<CompetitionInfoView> {
    
    private let provider = CompetitionInfoProvider()
    
    private var competition: Competition
    
    init(competition: Competition) {
        self.competition = competition
        super.init(nibName: nil, bundle: nil)
        
        title = "Описание"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.contentView.competitionTakePartView.participateButton.addTarget(self, action: #selector(slideToTeams), for: .touchUpInside)
        
        configure()
        updateCompetition()
    }
    
    private func configure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let fromDate = dateFormatter.date(from: competition.fromDate) ?? Date()
        let toDate = dateFormatter.date(from: competition.toDate) ?? Date()
        
        dateFormatter.dateFormat = "dd.MM"
        let fromDateString = dateFormatter.string(from: fromDate)
        let toDateString = dateFormatter.string(from: toDate)
        mainView.contentView.competitionTakePartView.datesLabel.text = "\(fromDateString)-\(toDateString)"
        
        mainView.contentView.competitionTakePartView.teamsLabel.text = "\(competition.countTeams)"
        mainView.contentView.competitionTakePartView.isJoined = competition.isJoined
        mainView.contentView.descriptionLabel.text = competition.description
        
        mainView.contentView.partnersStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        competition.partners.forEach { partner in
            let view = CompetitionPartnerView()
            view.nameLabel.text = partner.name
            mainView.contentView.partnersStackView.addArrangedSubview(view)
        }
    }
    
    private func updateCompetition() {
        provider.updateCompetition(competitionId: competition.id) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let competition):
                self.competition = competition
                self.configure()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func slideToTeams() {
        if let pagerViewController = parent?.parent as? PagerViewController {
            pagerViewController.scrollToNext(animated: true, completion: nil)
        }
    }
    
}
