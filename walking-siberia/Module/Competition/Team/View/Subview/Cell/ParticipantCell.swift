import UIKit
import SnapKit

class ParticipantCell: UICollectionViewCell {
    
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
    
    let stepsCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .right
        
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .right
        
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderWidth = 0.0
        contentView.layer.borderColor = R.color.graphicBlue()?.cgColor
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(stepsCountLabel)
        contentView.addSubview(distanceLabel)
        
        addShadow()
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
    
    func setupConstraints() {
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12.0)
            make.size.equalTo(48.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(12.0)
        }
        
        stepsCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18.0)
            make.left.equalTo(nameLabel.snp.right).offset(8.0)
            make.right.equalToSuperview().offset(-12.0)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(stepsCountLabel.snp.bottom).offset(4.0)
            make.left.equalTo(nameLabel.snp.right).offset(8.0)
            make.right.equalToSuperview().offset(-12.0)
        }
    }
}
