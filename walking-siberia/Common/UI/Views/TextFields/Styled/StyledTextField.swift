import UIKit

class StyledTextField: UITextField {
        
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: R.color.greyText() ?? .gray,
                                                                                               .font: font ?? .systemFont(ofSize: 14.0)])
        }
    }
    
    override var leftView: UIView? {
        didSet {
            leftViewMode = .always
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 40.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = R.color.mainContent()
        font = R.font.geometriaMedium(size: 14.0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineColor = R.color.greyText() ?? .gray
        underlined(color: underlineColor)
    }

}

