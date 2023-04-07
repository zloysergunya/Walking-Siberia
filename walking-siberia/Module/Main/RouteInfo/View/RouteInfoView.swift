import UIKit
import SnapKit

class RouteInfoView: RootView {
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.chevronLeft24()?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = R.color.activeElements()
        button.layer.cornerRadius = 3.0
        
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    let contentView = RouteInfoContentView()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(scrollView)
        addSubview(backButton)
        
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalToSuperview().offset(20.0)
            make.size.equalTo(24.0)
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
