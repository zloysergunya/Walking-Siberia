import Foundation
import AuthenticationServices
import CryptoKit
import Firebase

protocol AppleSignInServiceInput {
    func performRequest()
}

protocol AppleSignInServiceOutput: AnyObject {
    func appleSignIn(didFailWith error: Error)
    func appleSignIn(didSucceedWith token: String)
    func appleSignIn(didGet fullName: FullName)
}

class AppleSignInService: NSObject {
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    weak var output: AppleSignInServiceOutput?
    
    fileprivate var currentNonce: String?
    
    private var viewController: UIViewController
    private let appleIDProvider = ASAuthorizationAppleIDProvider()
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap({ String(format: "%02x", $0) }).joined()

      return hashString
    }
    
    private func signIn(idToken: String, nonce: String) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        Auth.auth().signIn(with: credential) { authResult, error in
            authResult?.user.getIDToken { [weak self] token, error in
                if let token = token {
                    self?.output?.appleSignIn(didSucceedWith: token)
                } else if let error = error {
                    self?.output?.appleSignIn(didFailWith: error)
                } else {
                    self?.output?.appleSignIn(didFailWith: ModelError())
                }
            }
        }
    }
    
}

// MARK: - AppleSignInServiceInput
extension AppleSignInService: AppleSignInServiceInput {
    
    func performRequest() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleSignInService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = appleIDCredential.identityToken,
              let idToken = String(data: idTokenData, encoding: .utf8),
              let nonce = currentNonce
        else {
            return
        }
        
        output?.appleSignIn(didGet: .init(firstName: appleIDCredential.fullName?.givenName,
                                          lastName: appleIDCredential.fullName?.familyName))
        signIn(idToken: idToken, nonce: nonce)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let error = error as? ASAuthorizationError {
            log.error(error.localizedDescription)
            if error.code == .canceled { return }
        } else {
            log.error("Unknown error \( error)")
        }
        
        output?.appleSignIn(didFailWith: error)
    }
    
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AppleSignInService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        viewController.view.window ?? .init(frame: UIScreen.main.bounds)
    }
    
}
