import UIKit
import SnapKit
import Atributika

class ArticleContentView: RootView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let sourceLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.font = R.font.geometriaRegular(size: 12.0) ?? .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = R.color.mainContent() ?? .black
        label.numberOfLines = 0
        
        return label
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(textLabel)
        addSubview(sourceLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(304.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(12.0)
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
        
    }
    
}
