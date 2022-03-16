import Foundation

class ProfileProvider {
    
    func loadProfile(completion: @escaping(Result<User, ModelError>) -> Void) {
        ProfileAPI.profileGet { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func loadCompetitions(completion: @escaping(Result<[Competition], ModelError>) -> Void) {
        CompetitionAPI.competitionGet { response, error in
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
