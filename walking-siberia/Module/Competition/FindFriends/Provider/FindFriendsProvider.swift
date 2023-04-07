import Foundation

class FindFriendsProvider {
    
    var page: Int = 1
    
    func loadFriends(isDisabled: Bool, search: String, completion: @escaping(Result<[User], ModelError>) -> Void) {
        let friendsInvitesRequest = FriendsInvitesRequest(disabled: isDisabled,
                                                          search: search,
                                                          limit: Constants.pageLimit,
                                                          page: page)
        FriendsAPI.friendsInvitesGet(friendsInvitesRequest: friendsInvitesRequest) { [weak self] response, error in
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
    
    func addUser(teamId: Int, userId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        let teamAddUserRequest = TeamAddUserRequest(teamId: teamId, userId: userId)
        TeamsAPI.teamAddUserPost(teamAddUserRequest: teamAddUserRequest) { response, error in
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
    
    func deleteUser(teamId: Int, userId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        let teamDeleteUserRequest = TeamDeleteUserRequest(teamId: teamId, userId: userId)
        TeamsAPI.teamDeleteUserPost(teamDeleteUserRequest: teamDeleteUserRequest) { response, error in
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
