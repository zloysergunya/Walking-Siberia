import UIKit

class StyledTextField: UITextField {
        
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: R.color.greyText() ?? .gray])
        }
    }
    
    override var leftView: UIView? {
        didSet {
            leftViewMode = .always
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = R.color.mainContent()
        font = R.font.geometriaMedium(size: 14.0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

