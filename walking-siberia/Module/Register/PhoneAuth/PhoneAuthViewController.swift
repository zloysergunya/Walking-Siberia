import UIKit
import SnapKit
import Firebase

class PhoneAuthViewController: ViewController<PhoneAuthView> {
    
    private let provider = PhoneAuthProvider()
    
    private lazy var phoneSignInService = PhoneSignInService(uiDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneSignInService.output = self
        
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
        
        let formattedPhone =  String(phone.phonePattern(pattern: "+###########", replacmentCharacter: "#"))        
        sendCode(to: formattedPhone)
    }
    
    private func sendCode(to phone: String) {
        mainView.continueButton.isLoading = true
        phoneSignInService.performRequest(phone: phone)
    }
    
}

// MARK: - UITextFieldDelegate
extension PhoneAuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        textField.text = textField.text?.phonePattern(pattern: "+# (###) ### ## ##", replacmentCharacter: "#")
        
        mainView.continueButton.isActive = !replacedText.isEmpty
        
        return true
    }
    
}

// MARK: - ConstraintKeyboardObserver
extension PhoneAuthViewController: ConstraintKeyboardObserver {
    var keyboardConstraint: Constraint { mainView.continueButtonBottomConstraint }
    var inset: CGFloat { -26.0 }
}

// MARK: - PhoneSignInServiceOutput
extension PhoneAuthViewController: PhoneSignInServiceOutput {
    
    func phoneSignIn(didFailWith error: Error) {
        mainView.continueButton.isLoading = false
        showError(text: error.localizedDescription)
    }
    
    func phoneSignIn(didSucceedWith verificationId: String, phone: String) {
        mainView.continueButton.isLoading = false
        navigationController?.pushViewController(PhoneCodeAuthViewController(phone: phone), animated: true)
    }
    
    func phoneSignIn(didSucceedWith token: String) {}
    
}

// MARK: - AuthUIDelegate
extension PhoneAuthViewController: AuthUIDelegate {
    
}
