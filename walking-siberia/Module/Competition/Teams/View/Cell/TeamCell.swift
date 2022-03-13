import UIKit
import SnapKit

class TeamCell: UICollectionViewCell {
    
    let imageViewBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24.0
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
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
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
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
        
        contentView.addSubview(imageViewBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(stepsCountLabel)
        
        addShadow(shadowRadius: 16.0, color: .black.withAlphaComponent(0.06))
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        imageViewBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12.0)
            make.size.equalTo(48.0)
        }
        
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18.0)
            make.left.equalTo(imageView.snp.right).offset(12.0)
            make.right.lessThanOrEqualTo(stepsCountLabel.snp.left).offset(-8.0)
        }
        
        categoryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
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
