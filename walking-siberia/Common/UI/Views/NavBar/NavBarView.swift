import UIKit
import SnapKit

struct NavBarConfiguration {
    let title: String?
    let subtitle: String?
    let leftButtonImage: UIImage?
    let rightButtonImage: UIImage?
}

class NavBarView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textAlignment = .center
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 48.0)
    }
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0)
        button.tintColor = R.color.activeElements()
        button.isHidden = true
        
        return button
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 4.0)
        button.tintColor = R.color.activeElements()
        button.isHidden = true
        
        return button
    }()
    
    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = newValue == nil
        }
    }
    
    var subtitle: String? {
        get { subtitleLabel.text }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue == nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titlesStackView)
        addSubview(leftButton)
        addSubview(rightButton)
        
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with configuration: NavBarConfiguration) {
        if let title = configuration.title {
            self.title = title
        }
        
        if let subtitle = configuration.subtitle {
            self.subtitle = subtitle
        }
        
        if let leftButtonImage = configuration.leftButtonImage {
            leftButton.setImage(leftButtonImage, for: .normal)
            leftButton.isHidden = false
        }
        
        if let rightButtonImage = configuration.rightButtonImage {
            rightButton.setImage(rightButtonImage, for: .normal)
            rightButton.isHidden = false
        }
    }
    
    private func setupConstraints() {
        
        leftButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(48.0)
        }
        
        titlesStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(48.0)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.size.equalTo(48.0)
        }
        
    }

}
