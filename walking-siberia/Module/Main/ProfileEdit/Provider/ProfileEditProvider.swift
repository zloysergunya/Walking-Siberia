import Foundation

class ProfileEditProvider {
    
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
    
    func uploadAvatar(photo: URL?, completion: @escaping(Result<SuccessResponse<EmptyData>, Error>) -> Void) {
        ProfileAPI.profileAvatarPost(photo: photo) { response, error in
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
