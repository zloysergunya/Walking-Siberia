import Foundation

class PhoneCodeAuthProvider {
    
    func confirmPhone(phone: String, code: String, completion: @escaping(Result<SuccessResponse<AuthConfirmResponse>, Error>) -> Void) {
        AuthAPI.authConfirmPost(authConfirm: AuthConfirmRequest(phone: phone, code: code)) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
    func resendCode(phone: String, completion: @escaping(Result<SuccessResponse<EmptyData>, Error>) -> Void) {
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
