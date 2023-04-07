import Foundation

class UserProfileProvider {
    
    func loadUser(id: Int, completion: @escaping(Result<User, ModelError>) -> Void) {
        FriendsAPI.friendsViewUidGet(userId: id) { response, error in
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
    
    func addFriend(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        FriendsAPI.friendsAddPost(friendsAddRequest: FriendsAddRequest(friendId: id)) { response, error in
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
    
    func removeFriend(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        FriendsAPI.friendsDeletePost(friendsDeleteRequest: FriendsDeleteRequest(friendId: id)) { response, error in
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
    
    func loadCompetitions(userId: Int, completion: @escaping(Result<[Competition], ModelError>) -> Void) {
        CompetitionAPI.competitionsUserUidGet(userId: userId) { response, error in
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
    
    func loadUserTeam(id: Int, completion: @escaping(Result<Team?, ModelError>) -> Void) {
        TeamsAPI.userTeamByUserUidGet(id: id) { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else{
                completion(.success(response?.data))
            }
        }
    }
    
    func loadAchievements(id: Int, completion: @escaping(Result<[Achievement], ModelError>) -> Void) {
        AchievementAPI.achievementTeamUidGet(id: id) { response, error in
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
