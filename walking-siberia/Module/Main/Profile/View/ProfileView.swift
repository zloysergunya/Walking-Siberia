import UIKit
import SnapKit

class ProfileView: RootView {
    
    let statsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.chart28(), for: .normal)
        
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.settings24(), for: .normal)
        
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = false
        
        return scrollView
    }()
    
    let contentView = ProfileContentView()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(scrollView)
        addSubview(statsButton)
        addSubview(settingsButton)
        
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        statsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(28.0)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(28.0)
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
