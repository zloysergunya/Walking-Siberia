import UIKit
import SnapKit

class PhoneAuthViewController: ViewController<PhoneAuthView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.continueButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        mainView.phoneTextField.delegate = self
        mainView.phoneTextField.becomeFirstResponder()
    }
    
    @objc private func nextStep() {
        guard let phone = mainView.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty else {
            Animations.shake(view: mainView.phoneTextField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        let formattedPhone =  String(phone.phonePattern(pattern: "###########", replacmentCharacter: "#").dropFirst())
        
        print("phone", phone, "formattedPhone", formattedPhone)
    }
    
}

// MARK: - UITextFieldDelegate
extension PhoneAuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        mainView.continueButton.isActive = !replacedText.isEmpty
        
        textField.text = textField.text?.phonePattern(pattern: "+# (###) ### ## ##", replacmentCharacter: "#")
        
        return true
    }
    
}

// MARK: - ConstraintKeyboardObserver
extension PhoneAuthViewController: ConstraintKeyboardObserver {
    var keyboardConstraint: Constraint { mainView.continueButtonBottomConstraint }
    var inset: CGFloat { -26.0 }
}
