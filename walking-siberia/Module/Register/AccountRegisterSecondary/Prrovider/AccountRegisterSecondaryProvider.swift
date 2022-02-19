import Foundation

class AccountRegisterSecondaryProvider {
    
    func profileUpdate(profileUpdate: ProfileUpdateRequest, completion: @escaping(Result<SuccessResponse<User>, Error>) -> Void) {
        ProfileAPI.profileUpdatePost(profileUpdate: profileUpdate) { response, error in
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
