import UIKit
import AuthenticationServices
import Atributika
import SafariServices

class OnboardingViewController: ViewController<OnboardingView> {
    
    private let provider = OnboardingProvider()
    
    private var fullName: FullName?
    private lazy var appleSignInService = AppleSignInService(viewController: self)
    private lazy var googleSignInService = GoogleSignInService(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleSignInService.output = self
        googleSignInService.output = self
        
        mainView.signInByPhoneButton.addTarget(self, action: #selector(openPhoneAuth), for: .touchUpInside)
        mainView.signInByAppleButton.addTarget(self, action: #selector(signInByApple), for: .touchUpInside)
        mainView.signInByGoogleButton.addTarget(self, action: #selector(signInByGoogle), for: .touchUpInside)

        configure()
    }
    
    private func configure() {
        
        let a = Style("a")
            .underlineStyle(NSUnderlineStyle.single).underlineColor(mainView.policyLabel.textColor)
            .foregroundColor(mainView.policyLabel.textColor.withAlphaComponent(0.5), .highlighted)
        
        let policyText = "Создавая аккаунт, вы принимаете\n<a href='\(Constants.agreementUrl)'>условия использования</a>"
        mainView.policyLabel.attributedText = policyText.style(tags: a)
        mainView.policyLabel.onClick = { [weak self] label, detection in
            self?.handleOnClick(label: label, detection: detection)
        }
    }
    
    private func handleOnClick(label: AttributedLabel, detection: Detection) {
        switch detection.type {
        case .tag(let tag):
            if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                openSafari(url: url)
            }
            
        default: break
        }
    }
    
    private func openSafari(url: URL) {
        present(SFSafariViewController(url: url), animated: true)
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
                
                if let firstName = self.fullName?.firstName {
                    UserSettings.user?.profile.firstName = firstName
                }
                if let lastName = self.fullName?.lastName {
                    UserSettings.user?.profile.lastName = lastName
                }
                
                authService?.authorize(with: response.accessToken, currentUserId: response.user.userId, withNotification: response.user.isFillProfile)
                
                if !response.user.isFillProfile {
                    self.navigationController?.pushViewController(AccountRegisterPrimaryViewController(), animated: true)
                }
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func openPhoneAuth() {
        UserSettings.authType = .phone
        navigationController?.pushViewController(PhoneAuthViewController(), animated: true)
    }
    
    @objc private func signInByApple() {
        UserSettings.authType = .apple
        appleSignInService.performRequest()
    }
    
    @objc private func signInByGoogle() {
        UserSettings.authType = .google
        googleSignInService.performRequest()
    }

}

// MARK: - AppleSignInServiceOutput
extension OnboardingViewController: AppleSignInServiceOutput {
    
    func appleSignIn(didFailWith error: Error) {
        showError(text: error.localizedDescription)
    }
    
    func appleSignIn(didSucceedWith token: String) {
        authByFirebase(token: token)
    }
    
    func appleSignIn(didGet fullName: FullName) {
        self.fullName = fullName
    }
        
}

// MARK: - GoogleSignInServiceOutput
extension OnboardingViewController: GoogleSignInServiceOutput {
    
    func googleSignIn(didFailWith error: Error) {
        showError(text: error.localizedDescription)
    }
    
    func googleSignIn(didSucceedWith token: String) {
        authByFirebase(token: token)
    }
    
    func googleSignIn(didGet fullName: FullName) {
        self.fullName = fullName
    }
    
}
