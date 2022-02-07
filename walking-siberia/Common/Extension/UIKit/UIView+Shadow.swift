import UIKit

extension UIView {
    
    func addShadow(opacity: Float = 0.25, offSet: CGSize = CGSize(width: 0, height: 0), shadowRadius: CGFloat = 4, color: UIColor = .black) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = offSet
    }
    
    func removeShadow() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.clear.cgColor
    }
    
}
