import Foundation
import GoogleSignIn
import Firebase

protocol GoogleSignInServiceInput {
    func performRequest()
}

protocol GoogleSignInServiceOutput: AnyObject {
    func googleSignIn(didFailWith error: Error)
    func googleSignIn(didSucceedWith token: String)
    func googleSignIn(didGet fullName: FullName)
}

class GoogleSignInService: NSObject {
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    weak var output: GoogleSignInServiceOutput?
    
    private var viewController: UIViewController
    private let clientID = "1096405923820-1ent5uf8gvvunacs3r24jaanra5mduia.apps.googleusercontent.com"
    
    private func signIn(idToken: String, accessToken: String) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signIn(with: credential) { authResult, error in
            authResult?.user.getIDToken { [weak self] token, error in
                if let token = token {
                    self?.output?.googleSignIn(didSucceedWith: token)
                } else if let error = error {
                    self?.output?.googleSignIn(didFailWith: error)
                } else {
                    self?.output?.googleSignIn(didFailWith: ModelError())
                }
            }
        }
    }
}

// MARK: - AppleSignInServiceInput
extension GoogleSignInService: GoogleSignInServiceInput {
    
    func performRequest() {
        let configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: viewController) { [weak self] user, error in
            self?.output?.googleSignIn(didGet: .init(firstName: user?.profile?.givenName,
                                              lastName: user?.profile?.familyName))
            if let user = user, let idToken = user.authentication.idToken {
                self?.signIn(idToken: idToken, accessToken: user.authentication.accessToken)
            } else if let error = error {
                self?.output?.googleSignIn(didFailWith: error)
            } else {
                self?.output?.googleSignIn(didFailWith: ModelError())
            }
        }
    }
    
}
