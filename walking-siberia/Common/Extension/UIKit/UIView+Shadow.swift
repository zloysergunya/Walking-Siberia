import UIKit

extension UIView {
    
    func addShadow(opacity: Float = 1.0, offSet: CGSize = CGSize(width: 0.0, height: 4.0), shadowRadius: CGFloat = 20.0, color: UIColor = .black.withAlphaComponent(0.08)) {
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
