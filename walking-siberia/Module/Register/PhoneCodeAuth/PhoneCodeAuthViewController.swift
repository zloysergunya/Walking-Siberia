import UIKit
import SnapKit
import Firebase

class PhoneCodeAuthViewController: ViewController<PhoneCodeAuthView> {

    private let phone: String
    private let provider = PhoneCodeAuthProvider()
    
    private lazy var phoneSignInService = PhoneSignInService(uiDelegate: self)
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
        
        hideKeyboardWhenTappedAround()
        
        phoneSignInService.output = self
        
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
        phoneSignInService.confirmRequest(code: code)
    }
    private func authByFirebase(token: String) {
        showLoader()
        provider.authByFirebase(token: token) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.hideLoader()
            
            switch result {
            case .success(let response):
                let authService: AuthService? = ServiceLocator.getService()
                UserSettings.user = response.user
                UserSettings.userReady = response.user.isFillProfile
                authService?.authorize(with: response.accessToken, currentUserId: response.user.userId, withNotification: response.user.isFillProfile)
                
                if !response.user.isFillProfile {
                    self.navigationController?.pushViewController(AccountRegisterPrimaryViewController(), animated: true)
                }
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func resendCode() {
        mainView.resendCodeButton.isLoading = true
        phoneSignInService.performRequest(phone: phone)
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

// MARK: - PhoneSignInServiceOutput
extension PhoneCodeAuthViewController: PhoneSignInServiceOutput {
    
    func phoneSignIn(didFailWith error: Error) {
        showError(text: error.localizedDescription)
    }
    
    func phoneSignIn(didSucceedWith verificationId: String, phone: String) {}
    
    func phoneSignIn(didSucceedWith token: String) {
        authByFirebase(token: token)
    }
    
}

// MARK: - AuthUIDelegate
extension PhoneCodeAuthViewController: AuthUIDelegate {
    
}
