import UIKit
import SnapKit

class PhoneCodeAuthViewController: ViewController<PhoneCodeAuthView> {
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.resendCodeButton.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        mainView.changePhoneButton.addTarget(self, action: #selector(changePhone), for: .touchUpInside)
        
        mainView.oneTimeCodeField.otpDelegate = self
        mainView.oneTimeCodeField.becomeFirstResponder()
        
        startTimer()
    }
    
    private func startTimer() {
        let endDate = Date().addingTimeInterval(30)
        updateResendCodeLabel(endDate: endDate)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.updateResendCodeLabel(endDate: endDate)
        }
    }
    
    private func updateResendCodeLabel(endDate: Date) {
        let diff = Int(endDate.timeIntervalSinceNow)
        if diff > 0 {
            mainView.resendCodeLabel.text = "Вы сможете отправить код повторно через \(String(format: "%02d:%02d", diff / 60, diff))"
            mainView.resendCodeButton.isHidden = true
        } else {
            mainView.resendCodeLabel.text = nil
            mainView.resendCodeButton.isHidden = false
            timer?.invalidate()
        }
    }
    
    @objc private func resendCode() {
        startTimer()
    }
    
    @objc private func changePhone() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - OTPTextFieldDelegate
extension PhoneCodeAuthViewController: OTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        print("didUserFinishEnter", code)
    }
    
}

// MARK: - ConstraintKeyboardObserver
extension PhoneCodeAuthViewController: ConstraintKeyboardObserver {
    var keyboardConstraint: Constraint { mainView.changePhoneButtonBottomConstraint }
    var inset: CGFloat { -26.0 }
}
