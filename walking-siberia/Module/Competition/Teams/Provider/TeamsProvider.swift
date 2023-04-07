import Foundation

class TeamsProvider {
    
    var page: Int = 1
    
    func loadTeams(uid: Int, searchText: String, isDisabled: Bool, completion: @escaping(Result<[Team], ModelError>) -> Void) {
        let teamsUidRequest = TeamsUidRequest(uid: uid, name: searchText, disabled: isDisabled, limit: Constants.pageLimit, page: page)
        TeamsAPI.teamsUidStatsGet(teamsUidRequest: teamsUidRequest) { [weak self] response, error in
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
    
    func loadUserTeam(completion: @escaping(Result<Team?, ModelError>) -> Void) {
        TeamsAPI.userTeamGet { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else{
                completion(.success(response?.data))
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
    
    func joinCompetition(competitionId: Int, teamId: Int, completion: @escaping(Result<EmptyData?, ModelError>) -> Void) {
        let competitionTeamJoinRequest = CompetitionTeamJoinRequest(competitionId: competitionId, teamId: teamId)
        CompetitionAPI.competitionTeamJoinPost(competitionTeamJoinRequest: competitionTeamJoinRequest) { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.success(response?.data))
            }
        }
    }
    
    func leaveCompetition(competitionId: Int, teamId: Int, completion: @escaping(Result<EmptyData?, ModelError>) -> Void) {
        let competitionTeamLeaveRequest = CompetitionTeamLeaveRequest(competitionId: competitionId, teamId: teamId)
        CompetitionAPI.competitionTeamLeavePost(competitionTeamLeaveRequest: competitionTeamLeaveRequest) { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.success(response?.data))
            }
        }
    }
}
