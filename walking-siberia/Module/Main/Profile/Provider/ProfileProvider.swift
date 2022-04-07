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
    
}
