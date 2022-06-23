import UIKit
import PinLayout

class NotificationCell: UICollectionViewCell {
    
    let unreadView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xE4302B)
        view.layer.cornerRadius = 4.0
        
        return view
    }()
    
    let typeImageView = UIImageView()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.activeElements()
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.close20(), for: .normal)
        button.tintColor = R.color.activeElements()
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(unreadView)
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {

        unreadView.pin
            .top(18.0)
            .left(12.0)
            .size(CGSize(width: 8.0, height: 8.0))
        
        typeImageView.pin
            .top(12.0)
            .left(12.0)
            .size(CGSize(width: 20.0, height: 20.0))
        
        if !unreadView.isHidden {
            typeImageView.pin.after(of: unreadView).marginLeft(4.0)
        }
        
        removeButton.pin
            .top(12.0)
            .right(12.0)
            .size(CGSize(width: 20.0, height: 20.0))
        
        typeLabel.pin
            .top(14.0)
            .after(of: typeImageView).marginLeft(4.0)
            .before(of: removeButton).marginRight(8.0)
            .height(16.0)
        
        titleLabel.pin
            .below(of: typeImageView).marginTop(8.0)
            .left(12.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        messageLabel.pin
            .below(of: titleLabel).marginTop(4.0)
            .left(12.0)
            .right(12.0)
            .sizeToFit(.widthFlexible)
        
        contentView.pin.height(messageLabel.frame.maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width - 12.0 * 2)
        layout()
        
        return contentView.frame.size
    }
    
}
