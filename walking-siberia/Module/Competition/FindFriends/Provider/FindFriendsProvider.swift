import Foundation

class FindFriendsProvider {
    
    var page: Int = 1
    
    func loadFriends(filter: String, completion: @escaping(Result<[User], ModelError>) -> Void) {
        let friendsRequest = FriendsRequest(filter: filter, limit: Constants.pageLimit, page: page)
        FriendsAPI.friendsGet(friendsRequest: friendsRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
