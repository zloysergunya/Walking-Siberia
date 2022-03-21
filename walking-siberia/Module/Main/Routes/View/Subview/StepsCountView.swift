import UIKit
import SnapKit
import Atributika

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
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
    
        return view
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 2
        
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(logoImageView)
        addSubview(stepsLabel)
        addSubview(separator)
        addSubview(distanceLabel)
        
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
        
    }
    
    func setup(with stepsCount: Int, distance: Double) {
        let bold = Style("bold")
            .foregroundColor(.white)
            .font(R.font.geometriaBold(size: 24.0) ?? .boldSystemFont(ofSize: 24.0))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let stepsText = "<bold>\(formatter.string(from: NSNumber(value: stepsCount)) ?? "\(stepsCount)")</bold>\nшаги"
        stepsLabel.attributedText = stepsText.style(tags: bold).attributedString
        
        let distanceText = "<bold>\(String(format: "%.2f", distance)) км</bold>\nдистанция"
        distanceLabel.attributedText = distanceText.style(tags: bold).attributedString
    }
    
}
