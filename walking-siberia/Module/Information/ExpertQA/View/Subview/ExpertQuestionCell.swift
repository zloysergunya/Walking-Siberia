import UIKit
import PinLayout

class ExpertQuestionCell: UICollectionViewCell {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.activeElements()
        label.numberOfLines = 0
        
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 14.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let chevronRightImageView = UIImageView(image: R.image.chevronRight24())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)
        contentView.addSubview(chevronRightImageView)                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    private func layout() {
        questionLabel.pin
            .top(12.0)
            .left(12.0)
            .right(32.0)
            .sizeToFit(.widthFlexible)
        
        var maxY = questionLabel.frame.maxY
        
        chevronRightImageView.pin
            .height(24.0)
            .width(24.0)
            .right(12.0)
            .vCenter(to: questionLabel.edge.vCenter)
        
        if !answerLabel.isHidden {
            answerLabel.pin
                .below(of: questionLabel).marginTop(8.0)
                .left(12.0)
                .right(12.0)
                .sizeToFit(.widthFlexible)
            
            maxY = answerLabel.frame.maxY
        }
        
        print("!!!!maxY + 12.0", maxY + 12.0)
        chevronRightImageView.transform = .identity.rotated(by: answerLabel.isHidden ? 0 : .pi / 2)
                
        contentView.pin.height(maxY + 12.0)
        pin.height(maxY + 12.0)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        
        return contentView.frame.size
    }
    
}
