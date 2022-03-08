import UIKit
import SnapKit

class CompetitionInfoView: RootView {

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView = CompetitionInfoContentView()
        
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
}
