import Foundation

class PhoneAuthProvider {
    
    func authByFirebase(token: String, completion: @escaping(Result<AuthConfirmResponse, ModelError>) -> Void) {
        AuthAPI.authFirebasePost(authFirebase: AuthFirebaseRequest(token: token)) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
