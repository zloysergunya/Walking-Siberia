import UIKit
import SnapKit

class RoutesView: RootView {
    
    let statsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.chart28(), for: .normal)
        
        return button
    }()
    
    let notifyButton: BadgeButton = {
        let button = BadgeButton()
        button.setImage(R.image.bell28(), for: .normal)
        button.badgeBackgroundColor = .init(hex: 0xE4302B)
        button.badgeTextColor = .white
        button.badgeFont = R.font.geometriaMedium(size: 10.0)
        
        return button
    }()
    
    let stepsCountView = StepsCountView()
    
    let dropDownMenu = CityDropDownView(type: .routes)
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.refreshControl = UIRefreshControl()
        view.backgroundColor = .clear
        
        return view
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(statsButton)
        addSubview(notifyButton)
        addSubview(stepsCountView)
        addSubview(collectionView)
        addSubview(dropDownMenu)
        
        super.setup()
    }
    
    override func setupConstraints() {
        statsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(28.0)
        }
        
        notifyButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(28.0)
        }
        
        stepsCountView.snp.makeConstraints { make in
            make.top.equalTo(statsButton.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        dropDownMenu.snp.makeConstraints { make in
            make.top.equalTo(stepsCountView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stepsCountView.snp.bottom).offset(40.0)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
}
