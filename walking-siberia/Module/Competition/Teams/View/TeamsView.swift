import UIKit
import SnapKit

class TeamsView: RootView {
    
    let childrenButton: ChipsButton = {
        let button = ChipsButton()
        button.setTitle("Дети", for: .normal)
        button.tag = 10
        
        return button
    }()
    
    let studentButton: ChipsButton = {
        let button = ChipsButton()
        button.setTitle("Молодежь", for: .normal)
        button.tag = 20
        
        return button
    }()
    
    let adultButton: ChipsButton = {
        let button = ChipsButton()
        button.setTitle("Взрослые", for: .normal)
        button.tag = 30
        
        return button
    }()
    
    private lazy var topStackView = UIStackView(views: [
        childrenButton,
        studentButton,
        adultButton
    ], axis: .horizontal, spacing: 8.0)
    
    let pensionerButton: ChipsButton = {
        let button = ChipsButton()
        button.setTitle("Старшее поколение", for: .normal)
        button.tag = 40
        
        return button
    }()
    
    let manWithHIAButton: ChipsButton = {
        let button = ChipsButton()
        button.setTitle("Люди с ОВЗ", for: .normal)
        button.tag = 50
        
        return button
    }()
    
    private lazy var bottomStackView = UIStackView(views: [
        pensionerButton,
        manWithHIAButton
    ], axis: .horizontal, spacing: 8.0)
    
    private lazy var filterContainerStackView = UIStackView(views: [
        topStackView,
        bottomStackView
    ], spacing: 8.0)
    
    let teamsCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 100.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.refreshControl = UIRefreshControl()
        view.backgroundColor = .clear
        
        return view
    }()
    
    let createTeamButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.add72()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = R.color.activeElements()
        button.layer.cornerRadius = 28.0
        
        return button
    }()
    
    let takePartButton = ActiveButton()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(filterContainerStackView)
        addSubview(teamsCountLabel)
        addSubview(collectionView)
        addSubview(createTeamButton)
        addSubview(takePartButton)
        
        createTeamButton.addShadow()
        takePartButton.addShadow()
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        filterContainerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.left.equalToSuperview().offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        teamsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(filterContainerStackView.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(teamsCountLabel.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
        createTeamButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(12.0)
            make.size.equalTo(56.0)
        }
        
        takePartButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.height.equalTo(38.0)
        }
        
    }
    
}
