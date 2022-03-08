import UIKit
import SnapKit

class CompetitionTakePartView: RootView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.competitionTakePartBackground())
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let datesLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let datesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Даты соревнования"
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var datesStackView = UIStackView(views: [
        datesLabel,
        datesTitleLabel
    ], distribution: .fillProportionally)
    
    let teamsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let teamsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Команд-участников"
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var teamsStackView = UIStackView(views: [
        teamsLabel,
        teamsTitleLabel
    ], distribution: .fillProportionally)
    
    private lazy var textStackView = UIStackView(views: [
        datesStackView,
        teamsStackView
    ], axis: .horizontal, spacing: 12.0, distribution: .fillEqually)
    
    let participateButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Участвовать", for: .normal)
        
        return button
    }()

    var isJoined: Bool = false {
        didSet {
            participateButton.setTitle(isJoined ? "Далее" : "Участвовать", for: .normal)
        }
    }
    
    override func setup() {
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        
        addSubview(backgroundImageView)
        addSubview(participateButton)
        addSubview(textStackView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalTo(participateButton.snp.top).offset(-12.0)
        }
        
        participateButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(38.0)
        }
        
    }

}
