import UIKit
import SnapKit

class LaunchView: RootView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.launchView())
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(backgroundImageView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
