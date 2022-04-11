import UIKit
import SnapKit

class StepsCountView: UIView {
    
    private let logoImageView = UIImageView(image: R.image.logoSmall())
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: 0x2DA6DE).cgColor, UIColor(hex: 0x69CEF5).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.75)
        gradientLayer.cornerRadius = 12.0
        
        return gradientLayer
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание аккаунта (2/2)"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 16.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 24.0)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let stepsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "шаги"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
    
        return view
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = R.font.geometriaBold(size: 24.0)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let distanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "дистанция"
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0)
        
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        layer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(logoImageView)
        addSubview(stepsLabel)
        addSubview(stepsTitleLabel)
        addSubview(separator)
        addSubview(distanceLabel)
        addSubview(distanceTitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6.0)
            make.top.bottom.equalToSuperview()
            make.size.equalTo(70.0)
        }
        
        stepsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.greaterThanOrEqualTo(logoImageView.snp.right).offset(16.0)
            make.right.equalTo(separator.snp.left).offset(-16.0)
            make.width.equalTo(distanceLabel.snp.width)
        }
        
        stepsTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stepsLabel.snp.centerX)
            make.bottom.equalToSuperview().inset(16.0)
        }
        
        separator.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-126.0)
            make.top.bottom.equalToSuperview().inset(16.0)
            make.width.equalTo(1.0)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalTo(separator.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.width.equalTo(stepsLabel.snp.width)
        }
        
        distanceTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(distanceLabel.snp.centerX)
            make.bottom.equalToSuperview().inset(16.0)
        }
        
    }
    
    func setup(with stepsCount: Int, distance: Double) {
        let stepsText: String
        if stepsCount > 30000 {
            stepsText = "\(stepsCount.roundedWithAbbreviations)"
        } else {
            stepsText = "\(stepsCount)"
        }
        stepsLabel.text = stepsText
        
        let distanceText = "\(String(format: "%.2f", distance)) км"
        distanceLabel.text = distanceText
    }
    
}
