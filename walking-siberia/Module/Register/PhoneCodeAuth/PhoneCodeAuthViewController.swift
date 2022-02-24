import UIKit
import SnapKit

class PhoneCodeAuthViewController: ViewController<PhoneCodeAuthView> {

    private let phone: String
    private let provider = PhoneCodeAuthProvider()
    
    private var timer: Timer?
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func confirm(with code: String) {
        provider.confirmPhone(phone: phone, code: code) { [weak self] result in                        
            switch result {
            case .success(let response):
                let authService: AuthService? = ServiceLocator.getService()
                if let token = response.data?.accessToken, let user = response.data?.user {
                    UserSettings.user = user
                    authService?.authorize(with: token, currentUserId: user.userID)
                }
                
            case .failure(let error):
                error.localizedDescription // todo
            }
        }
    }
    
    @objc private func resendCode() {
        mainView.resendCodeButton.isLoading = true
        provider.resendCode(phone: phone) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.resendCodeButton.isLoading = false
            
            switch result {
            case .success(let response):
                print(response)
                self.startTimer()
                
            case .failure(let error):
                error.localizedDescription // todo
            }
        }
    }
    
    @objc private func changePhone() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - OTPTextFieldDelegate
extension PhoneCodeAuthViewController: OTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        confirm(with: code)
    }
    
}

// MARK: - ConstraintKeyboardObserver
extension PhoneCodeAuthViewController: ConstraintKeyboardObserver {
    var keyboardConstraint: Constraint { mainView.changePhoneButtonBottomConstraint }
    var inset: CGFloat { -26.0 }
}
