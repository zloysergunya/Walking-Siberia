import UIKit
import SnapKit

class CompetitionInfoContentView: RootView {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let competitionTakePartView = CompetitionTakePartView()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let partnersTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Партнеры"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let partnersStackView = UIStackView(views: [], spacing: 8.0, distribution: .fill)
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(nameLabel)
        addSubview(competitionTakePartView)
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
        addSubview(partnersTitleLabel)
        addSubview(partnersStackView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        competitionTakePartView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(130.0)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(competitionTakePartView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        partnersTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        partnersStackView.snp.makeConstraints { make in
            make.top.equalTo(partnersTitleLabel.snp.bottom).offset(4.0)
            make.left.bottom.right.equalToSuperview().inset(12.0)
        }
        
    }
    
}
