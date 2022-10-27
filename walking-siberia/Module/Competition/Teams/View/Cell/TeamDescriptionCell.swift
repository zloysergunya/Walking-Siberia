import UIKit
import PinLayout

class TeamDescriptionCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 14.0)
        label.textColor = R.color.greyText()
        label.numberOfLines = 0
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        label.pin
            .top()
            .left()
            .right()
            .sizeToFit(.widthFlexible)
        
        contentView.pin.height(label.frame.maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        
        return contentView.frame.size
    }
    
}
