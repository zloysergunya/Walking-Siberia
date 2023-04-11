import Foundation

class ProfileProvider {
    
    func loadProfile(completion: @escaping(Result<User, ModelError>) -> Void) {
        ProfileAPI.profileGet { response, error in
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
    
    func loadCompetitions(completion: @escaping(Result<[Competition], ModelError>) -> Void) {
        CompetitionAPI.myCompetitionsGet() { response, error in
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
