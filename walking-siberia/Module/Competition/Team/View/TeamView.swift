import UIKit
import SnapKit

class TeamView: RootView {
    
    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = R.color.greyBackground()
        let configuration = NavBarConfiguration(title: nil,
                                                subtitle: nil,
                                                leftButtonImage: R.image.chevronLeft24(),
                                                rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 112.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.refreshControl = UIRefreshControl()
        
        return view
    }()
    
    let actionButton: ActiveButton = {
        let button = ActiveButton()
        button.isHidden = true
        
        return button
    }()
    
    let deleteTeamButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Удалить команду", for: .normal)
        button.isHidden = true
        button.setTitleColor(R.color.activeElements(), for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = R.color.activeElements()?.cgColor
        
        return button
    }()
    
    private lazy var buttonStack = UIStackView(views: [
        actionButton,
        deleteTeamButton
    ], spacing: 8.0)
        
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(collectionView)
        addSubview(navBar)
        addSubview(buttonStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
    }
    
}
