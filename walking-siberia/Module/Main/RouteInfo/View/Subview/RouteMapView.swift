import UIKit
import SnapKit

class RouteMapView: RootView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карта"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let openMapButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Открыть карту", for: .normal)
        
        return button
    }()
        
    override func setup() {
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(openMapButton)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(171.0)
        }
        
        openMapButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(38.0)
        }
    }
    
}
