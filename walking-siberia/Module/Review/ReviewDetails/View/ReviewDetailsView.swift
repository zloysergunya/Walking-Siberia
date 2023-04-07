import UIKit
import SnapKit

class ReviewDetailsView: RootView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let containerShadowView: UIView = {
        let view = UIView()
        view.addShadow()
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(nameLabel)
        addSubview(containerShadowView)
        
        containerShadowView.addSubview(containerView)
        
        containerView.addSubview(textLabel)
        containerView.addSubview(usernameLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        containerShadowView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(containerShadowView.snp.edges)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12.0)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(16.0)
            make.left.right.bottom.equalToSuperview().inset(12.0)
        }
    }
    
}
