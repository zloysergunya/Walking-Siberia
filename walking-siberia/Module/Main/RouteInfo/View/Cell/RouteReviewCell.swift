import UIKit
import SnapKit

class RouteReviewCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 3
        
        return label
    }()
    
    private let moreLabel: UILabel = {
        let label = UILabel()
        label.text = "Читать далее"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.graphicBlue()
        label.isHidden = true
        
        return label
    }()
    
    override var bounds: CGRect {
        didSet {
            moreLabel.isHidden = !textLabel.isTruncated
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(moreLabel)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16.0)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(16.0)
        }
    }
    
}
