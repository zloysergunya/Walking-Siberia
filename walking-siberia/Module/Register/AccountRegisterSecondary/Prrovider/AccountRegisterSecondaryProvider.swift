import Foundation

class AccountRegisterSecondaryProvider {
    
    func profileUpdate(profileUpdate: ProfileUpdateRequest, completion: @escaping(Result<SuccessResponse<User>, ModelError>) -> Void) {
        ProfileAPI.profileUpdatePost(profileUpdate: profileUpdate) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func uploadAvatar(photo: URL?, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        ProfileAPI.profileAvatarPost(photo: photo) { response, error in
            if let response = response {
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
