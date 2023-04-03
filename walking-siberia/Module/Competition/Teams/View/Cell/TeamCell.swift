import UIKit
import SnapKit

class TeamCell: UICollectionViewCell {
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            if let gradientLayer = gradientLayer {
                imageViewBackgroundView.layer.addSublayer(gradientLayer)
            }
        }
    }
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    private lazy var rootLabels = UIStackView(views: [
        nameLabel,
        placeLabel
    ], spacing: 4.0)

    let stepsCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 10.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderColor = R.color.graphicBlue()?.cgColor
        contentView.layer.borderWidth = 0.0
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(rootLabels)
        contentView.addSubview(stepsCountLabel)
        
        addShadow(shadowRadius: 16.0, color: .black.withAlphaComponent(0.06))
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        gradientLayer = nil
    }
    
    private func setupConstraints() {
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12.0)
            make.size.equalTo(48.0)
        }
        
        rootLabels.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rootLabels.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(12.0)
            make.right.lessThanOrEqualTo(stepsCountLabel.snp.left).offset(-8.0)
        }
        
        stepsCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        stepsCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18.0)
            make.right.equalToSuperview().offset(-12.0)
        }
    }
    
}
