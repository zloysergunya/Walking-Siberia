import Foundation

class UserProfileProvider {
    
    func loadUser(id: Int, completion: @escaping(Result<User, ModelError>) -> Void) {
        FriendsAPI.friendsViewUidGet(userId: id) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func addFriend(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        FriendsAPI.friendsAddPost(friendsAddRequest: FriendsAddRequest(friendId: id)) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func removeFriend(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        FriendsAPI.friendsDeletePost(friendsDeleteRequest: FriendsDeleteRequest(friendId: id)) { response, error in
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
