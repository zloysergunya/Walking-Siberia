import UIKit

protocol KeyboardObserver: AnyObject {
    func keyboardWillShowWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions)
    func keyboardDidShowWithFrame(_ frame: CGRect)
    func keyboardWillHideWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions)
    func keyboardDidHideWithFrame(_ frame: CGRect)
}

extension KeyboardObserver {
    func keyboardWillShowWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions) {}
    func keyboardDidShowWithFrame(_ frame: CGRect) { }
    func keyboardWillHideWithFrame(_ frame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions) {}
    func keyboardDidHideWithFrame(_ frame: CGRect) { }
}
