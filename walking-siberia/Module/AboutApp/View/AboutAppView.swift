import UIKit
import SnapKit

class AboutAppView: RootView {

    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = R.color.greyBackground()
        let configuration = NavBarConfiguration(title: "О приложении",
                                                      subtitle: nil,
                                                      leftButtonImage: R.image.chevronLeft24(),
                                                      rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = R.color.greyBackground()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = AboutAppContentView()
    
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
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
}
