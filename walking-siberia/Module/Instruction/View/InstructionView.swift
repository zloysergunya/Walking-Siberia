import UIKit
import SnapKit

class InstructionView: RootView {

    let navBar: NavBarView = {
        let view = NavBarView()
        view.backgroundColor = R.color.greyBackground()
        let configuration = NavBarConfiguration(title: "Инструкция",
                                                      subtitle: nil,
                                                      leftButtonImage: R.image.chevronLeft24(),
                                                      rightButtonImage: nil)
        view.configure(with: configuration)
        
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = InstructionContentView()
    
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
