import UIKit
import SnapKit

protocol ConstraintKeyboardObserver: KeyboardObserver, ViewProviding {
    var keyboardConstraint: Constraint { get }
}

private var oldConstraintValueAssociationKey: UInt8 = 0
extension ConstraintKeyboardObserver {
    
    private var oldConstraintConstant: CGFloat? {
        get { objc_getAssociatedObject(self, &oldConstraintValueAssociationKey) as? CGFloat }
        set {
            objc_setAssociatedObject(self, &oldConstraintValueAssociationKey, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func keyboardWillShowWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions) {
        oldConstraintConstant = oldConstraintConstant ?? self.keyboardConstraint.layoutConstraints.first?.constant

        let keyboardInset = max(0, frame.height - (oldConstraintConstant ?? 0.0))
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.keyboardAdjustingAnimationFor(willShowing: true, keyboardInset: -keyboardInset)
        })
    }
    
    func keyboardWillHideWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions) {
        let keyboardInset = max(0, view.frame.maxY - frame.minY)
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.keyboardAdjustingAnimationFor(willShowing: false, keyboardInset: keyboardInset)
            self.oldConstraintConstant = nil
        })
    }
    
    func keyboardAdjustingAnimationFor(willShowing: Bool, keyboardInset: CGFloat) {
        self.keyboardConstraint.update(offset: keyboardInset)
        self.view.layoutIfNeeded()
    }
    
}
