import Foundation

class UserListProvider {
    
    var page: Int = 1
    
    func loadFriends(filter: String, search: String, completion: @escaping(Result<[User], ModelError>) -> Void) {
        let friendsRequest = FriendsRequest(filter: filter, search: search, limit: Constants.pageLimit, page: page)
        FriendsAPI.friendsGet(friendsRequest: friendsRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func loadUsers(filter: String, search: String, completion: @escaping(Result<[User], ModelError>) -> Void) {
        let usersRequest = UsersRequest(filter: filter, search: search, limit: Constants.pageLimit, page: page)
        UsersAPI.usersGet(usersRequest: usersRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
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
