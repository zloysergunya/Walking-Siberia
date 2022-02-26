import Foundation

class ProfileProvider {
    
    func loadProfile(completion: @escaping(Result<SuccessResponse<User>, Error>) -> Void) {
        ProfileAPI.profileGet { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
    func loadCompetitions(completion: @escaping(Result<SuccessResponse<[Competition]>, Error>) -> Void) {
        CompetitionAPI.competitionGet { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
