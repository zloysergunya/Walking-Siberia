import UIKit
import SnapKit

class ArticleView: RootView {

    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = .clear
        let configuration = NavBarConfiguration(title: nil,
                                                subtitle: nil,
                                                leftButtonImage: R.image.chevronLeft24(),
                                                rightButtonImage: nil)
        view.configure(with: configuration)
        view.leftButton.imageView?.backgroundColor = .white
        view.leftButton.imageView?.layer.cornerRadius = 3.0
        
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = ArticleContentView()
        
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
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
}
