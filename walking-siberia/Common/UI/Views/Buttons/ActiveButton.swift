import UIKit

class ActiveButton: UIButton {
    
    var isActive: Bool = true {
        didSet {
            backgroundColor = isActive ? R.color.activeElements() : R.color.greyText()
            isUserInteractionEnabled = isActive
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = R.font.geometriaBold(size: 12.0)
        backgroundColor = R.color.activeElements()
        layer.cornerRadius = 5.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
