import Foundation

class TeamProvider {
    
    func updateTeam(teamId: Int, completion: @escaping(Result<Team, ModelError>) -> Void) {
        TeamsAPI.teamViewUidGet(teamId: teamId) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func loadMyTeam(competitionId: Int, completion: @escaping(Result<Team, ModelError>) -> Void) {
        TeamsAPI.myteamUidGet(competitionId: competitionId) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            }
        }
    }
    
    func joinTeam(teamId: Int, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        TeamsAPI.teamJoinPost(teamJoinRequest: TeamJoinRequest(teamId: teamId)) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
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
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
