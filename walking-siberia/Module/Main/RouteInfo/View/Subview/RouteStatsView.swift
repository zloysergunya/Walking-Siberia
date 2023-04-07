import UIKit
import SnapKit

class RouteStatsView: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.like32(), for: .normal)
        button.setImage(R.image.likeFill32(), for: .selected)
        
        return button
    }()
    
    private let leftSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.graphicBlue()
        
        return view
    }()
    
    private let extentImageView = UIImageView(image: R.image.location20())
    
    let extentLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 8.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let extentContainerView = UIView()
    
    let rateContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let middleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.graphicBlue()
        
        return view
    }()
    
    let rateImageView = UIImageView(image: R.image.like20())
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 8.0)
        label.textColor = R.color.mainContent()
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var rootStack = UIStackView(views: [
        extentContainerView,
        rateContainerView
    ], axis: .horizontal, alignment: .center)
    
    private let rightSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.graphicBlue()
        
        return view
    }()

    override func setup() {
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(leftSeparator)
        addSubview(rootStack)
        addSubview(middleSeparator)
        addSubview(rightSeparator)
        
        extentContainerView.addSubview(extentImageView)
        extentContainerView.addSubview(extentLabel)
        rateContainerView.addSubview(rateImageView)
        rateContainerView.addSubview(rateLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(likeButton.snp.left).offset(-16.0)
            make.centerY.equalTo(likeButton.snp.centerY)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.right.equalToSuperview()
            make.size.equalTo(32.0)
        }
        
        leftSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.left.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(30.0)
        }
        
        extentImageView.snp.makeConstraints { make in
            make.centerY.equalTo(extentLabel.snp.centerY)
            make.right.equalTo(extentLabel.snp.left).offset(-4.0)
            make.size.equalTo(20.0)
        }
        
        extentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        rateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(rateLabel.snp.centerY)
            make.right.equalTo(rateLabel.snp.left).offset(-4.0)
            make.size.equalTo(20.0)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        rootStack.snp.makeConstraints { make in
            make.centerY.equalTo(middleSeparator.snp.centerY)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        middleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(30.0)
        }
        
        rightSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.right.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(30.0)
        }
    }
    
}
