import Foundation

class AccountRegisterPrimaryProvider {
    
    func profileUpdate(profileUpdate: ProfileUpdateRequest, completion: @escaping(Result<SuccessResponse<User>, ModelError>) -> Void) {
        ProfileAPI.profileUpdatePost(profileUpdate: profileUpdate) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
