import Foundation

class ProfileProvider {
    
    func loadProfile(completion: @escaping(Result<SuccessResponse<User>, ModelError>) -> Void) {
        ProfileAPI.profileGet { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func loadCompetitions(completion: @escaping(Result<SuccessResponse<[Competition]>, ModelError>) -> Void) {
        CompetitionAPI.competitionGet { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
