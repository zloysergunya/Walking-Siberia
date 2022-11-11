import Foundation

class TeamEditProvider {
    
    var page: Int = 1
    
    func loadParticipants(teamId: Int, disabled: Bool, completion: @escaping(Result<[Participant], ModelError>) -> Void) {
        let teamUidUsers = TeamUidUsers(disabled: disabled, limit: Constants.pageLimit, page: page)
        TeamsAPI.teamUidUsersGet(teamId: teamId, teamUidUsers: teamUidUsers) { [weak self] response, error in
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
    
    func createTeam(teamCreateRequest: TeamCreateRequest, completion: @escaping(Result<Team, ModelError>) -> Void) {
        TeamsAPI.teamCreatePost(teamCreateRequest: teamCreateRequest) { response, error in
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
    
    func updateTeam(teamUpdateRequest: TeamUpdateRequest, completion: @escaping(Result<Team, ModelError>) -> Void) {
        TeamsAPI.teamUpdatePost(teamUpdateRequest: teamUpdateRequest) { response, error in
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
