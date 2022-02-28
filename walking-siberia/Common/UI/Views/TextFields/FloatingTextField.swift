import UIKit

class FloatingTextField: SkyFloatingLabelTextField {
    
    override var leftView: UIView? {
        didSet {
            leftViewMode = .always
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let primaryColor = R.color.mainContent() ?? .black
        let secondaryColor = R.color.greyText() ?? .gray
        
        font = R.font.geometriaMedium(size: 14.0)
        titleFont = R.font.geometriaRegular(size: 12.0) ?? .systemFont(ofSize: 12.0)
        placeholderFont = R.font.geometriaMedium(size: 14.0)
        
        textColor = primaryColor
        tintColor = primaryColor
        titleColor = primaryColor
        selectedTitleColor = primaryColor
        selectedLineColor = primaryColor
        
        placeholderColor = secondaryColor
        lineColor = secondaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
