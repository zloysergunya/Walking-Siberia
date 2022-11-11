import Foundation

class TeamProvider {
    
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
    
    func updateTeam(teamId: Int, completion: @escaping(Result<Team, ModelError>) -> Void) {
        TeamsAPI.teamViewUidGet(teamId: teamId) { response, error in
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
    
    func loadMyTeam(competitionId: Int, completion: @escaping(Result<Team?, ModelError>) -> Void) {
        TeamsAPI.myteamUidGet(competitionId: competitionId) { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.success(response?.data))
            }
        }
    }
    
    func joinTeam(teamId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        TeamsAPI.teamJoinPost(teamJoinRequest: TeamJoinRequest(teamId: teamId)) { response, error in
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
    
    func leaveTeam(teamId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        TeamsAPI.teamLeavePost(teamLeaveRequest: TeamLeaveRequest(teamId: teamId)) { response, error in
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
    
    func deleteTeam(teamId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        TeamsAPI.teamDeletePost(teamDeleteRequest: TeamDeleteRequest(teamId: teamId)) { response, error in
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
