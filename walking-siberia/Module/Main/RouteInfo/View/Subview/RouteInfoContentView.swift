import UIKit
import SnapKit

class RouteInfoContentView: RootView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
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
    
    private lazy var statsStackView = UIStackView(views: [
        extentContainerView,
        rateContainerView
    ], axis: .horizontal, alignment: .center)
    
    private let rightSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.graphicBlue()
        
        return view
    }()
    
    private let mapTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Карта"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let openMapButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Открыть карту", for: .normal)
        
        return button
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 16.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let placesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Интересные места"
        label.font = R.font.geometriaBold(size: 16.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    var placesCollectionHeightConstraint: Constraint!
    let placesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = true
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(leftSeparator)
        addSubview(statsStackView)
        addSubview(middleSeparator)
        addSubview(rightSeparator)
        addSubview(mapTitleLabel)
        addSubview(mapImageView)
        addSubview(openMapButton)
        addSubview(descriptionTitleLabel)
        addSubview(descriptionLabel)
        addSubview(placesTitleLabel)
        addSubview(placesCollectionView)
        
        extentContainerView.addSubview(extentImageView)
        extentContainerView.addSubview(extentLabel)
        rateContainerView.addSubview(rateImageView)
        rateContainerView.addSubview(rateLabel)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.width.equalTo(imageView.snp.height).multipliedBy(1.0 / 1.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.right.equalTo(likeButton.snp.left).offset(-16.0)
            make.centerY.equalTo(likeButton.snp.centerY)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(22.0)
            make.right.equalToSuperview().offset(-12.0)
            make.size.equalTo(32.0)
        }
        
        leftSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.left.equalToSuperview().offset(12.0)
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
        
        statsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(middleSeparator.snp.centerY)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        middleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(1.0)
            make.height.equalTo(30.0)
        }
        
        rightSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            make.right.equalToSuperview().offset(-12.0)
            make.width.equalTo(1.0)
            make.height.equalTo(30.0)
        }
        
        mapTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(leftSeparator.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        mapImageView.snp.makeConstraints { make in
            make.top.equalTo(mapTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(171.0)
        }
        
        openMapButton.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(38.0)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(openMapButton.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        placesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        placesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(placesTitleLabel.snp.bottom).offset(4.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.0)
            placesCollectionHeightConstraint = make.height.equalTo(140.0).constraint
        }
        
    }
    
}
