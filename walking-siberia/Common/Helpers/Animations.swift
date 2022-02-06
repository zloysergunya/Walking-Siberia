import UIKit

class Animations {
    
    static func shake(view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 8, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 8, y: view.center.y))

        view.layer.add(animation, forKey: "position")
    }
    
    static func press(view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = .identity
            })
        })
    }
    
    static func slideUpDown(view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.8
        animation.repeatCount = .greatestFiniteMagnitude
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y - 8.0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y + 8.0))

        view.layer.add(animation, forKey: "position")
    }
    
}
