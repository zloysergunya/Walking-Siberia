import Foundation

class TeamsProvider {
    
    var page: Int = 1
    
    func loadTeams(uid: Int, filter: String, completion: @escaping(Result<[Team], ModelError>) -> Void) {
        let teamsUidRequest = TeamsUidRequest(uid: uid, filter: filter, limit: Constants.pageLimit, page: page)
        TeamsAPI.teamsUidGet(teamsUidRequest: teamsUidRequest) { [weak self] response, error in
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
    
    func updateCompetition(competitionId: Int, completion: @escaping(Result<Competition, ModelError>) -> Void) {
        CompetitionAPI.competitionUidGet(competitionId: competitionId) { response, error in
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
