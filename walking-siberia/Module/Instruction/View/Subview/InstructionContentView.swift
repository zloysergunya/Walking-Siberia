import UIKit
import SnapKit

class InstructionContentView: RootView {
    
    private let mainTaskTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Главная задача приложения"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let mainTaskLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let prizesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Призы"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let prizesLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let creatingTeamTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание команды"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let creatingTeamLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let routesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Маршруты"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let routesLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let otherTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Прочее"
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaBold(size: 16.0)
        
        return label
    }()
    
    let otherLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    override func setup() {
        
        addSubview(mainTaskTitleLabel)
        addSubview(mainTaskLabel)
        addSubview(prizesTitleLabel)
        addSubview(prizesLabel)
        addSubview(creatingTeamTitleLabel)
        addSubview(creatingTeamLabel)
        addSubview(routesTitleLabel)
        addSubview(routesLabel)
        addSubview(otherTitleLabel)
        addSubview(otherLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {

        mainTaskTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        mainTaskLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTaskTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        prizesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTaskLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        prizesLabel.snp.makeConstraints { make in
            make.top.equalTo(prizesTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        creatingTeamTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(prizesLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        creatingTeamLabel.snp.makeConstraints { make in
            make.top.equalTo(creatingTeamTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        routesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(creatingTeamLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        routesLabel.snp.makeConstraints { make in
            make.top.equalTo(routesTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        otherTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(routesLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        otherLabel.snp.makeConstraints { make in
            make.top.equalTo(otherTitleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        
    }

}
