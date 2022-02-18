import Foundation

class PhoneAuthProvider {
    
    func sendCode(phone: String, completion: @escaping(Result<SuccessResponse, Error>) -> Void) {
        AuthAPI.authPost(auth: AuthRequest(phone: phone)) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
