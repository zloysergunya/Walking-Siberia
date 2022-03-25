import UIKit
import SnapKit

class VideoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 10.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let durationView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.mainContent()
        view.layer.cornerRadius = 2.0
        
        return view
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 10.0)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(viewsCountLabel)
        
        imageView.addSubview(durationView)
        durationView.addSubview(durationLabel)
        
        addShadow()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(162.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        viewsCountLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
        
        durationView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(3.0)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3.0)
        }
        
    }
    
}
