import UIKit
import SnapKit

class UserListView: RootView {
    
    let searchBar = SearchBar()

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
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 100.0, right: 0.0)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.refreshControl = UIRefreshControl()
        view.backgroundColor = .clear
        view.keyboardDismissMode = .onDrag
        
        return view
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(searchBar)
        addSubview(filterContainerStackView)
        addSubview(collectionView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(32.0)
        }
        
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16.0)
            make.left.equalToSuperview().offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterContainerStackView.snp.bottom).offset(8.0)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
}
