import Foundation
import FirebaseAuth

protocol PhoneSignInServiceInput {
    func performRequest(phone: String)
    func confirmRequest(code: String)
}

protocol PhoneSignInServiceOutput: AnyObject {
    func phoneSignIn(didFailWith error: Error)
    func phoneSignIn(didSucceedWith verificationId: String, phone: String)
    func phoneSignIn(didSucceedWith token: String)
}

class PhoneSignInService: NSObject {
    
    weak var output: PhoneSignInServiceOutput?
    
    private var uiDelegate: AuthUIDelegate?
    
    init(uiDelegate: AuthUIDelegate?) {
        self.uiDelegate = uiDelegate
        super.init()
    }
    
    private func signIn(verificationId: String, verificationCode: String) {
        let credential = FirebaseAuth.PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { authResult, error in
            authResult?.user.getIDToken { [weak self] token, error in
                if let token = token {
                    self?.output?.phoneSignIn(didSucceedWith: token)
                } else if let error = error {
                    self?.output?.phoneSignIn(didFailWith: error)
                } else {
                    self?.output?.phoneSignIn(didFailWith: ModelError())
                }
            }
        }
    }
    
}

// MARK: - PhoneSignInServiceInput
extension PhoneSignInService: PhoneSignInServiceInput {
    
    func performRequest(phone: String) {
        FirebaseAuth.PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: uiDelegate) { [weak self] verificationId, error in
            if let verificationId = verificationId {
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                self?.output?.phoneSignIn(didSucceedWith: verificationId, phone: phone)
            } else if let error = error {
                self?.output?.phoneSignIn(didFailWith: error)
            } else {
                self?.output?.phoneSignIn(didFailWith: NSError())
            }
        }
    }
    
    func confirmRequest(code: String) {
        guard let verificationId = UserDefaults.standard.string(forKey: "authVerificationID") else {
            output?.phoneSignIn(didFailWith: NSError())
            
            return
        }
        
        signIn(verificationId: verificationId, verificationCode: code)
    }
    
}
