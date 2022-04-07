import Foundation

class TeamEditProvider {
    
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
    
}
