import UIKit
import SnapKit

class ProfileEditView: RootView {
    
    let navBar: NavBarView = {
        let view = NavBarView()
        let configuration = NavBarConfiguration(title: "Настройки",
                                                      subtitle: nil,
                                                      leftButtonImage: R.image.chevronLeft24(),
                                                      rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()

    var scrollViewBottomConstraint: Constraint!
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = false
        scrollView.backgroundColor = R.color.greyBackground()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = ProfileEditContentView()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(scrollView)
        addSubview(navBar)
        
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.left.right.equalToSuperview()
            scrollViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
}
