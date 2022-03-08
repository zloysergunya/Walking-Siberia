import Foundation

class CompetitionsProvider {
    
    func loadCompetitions(completion: @escaping(Result<[Competition], Error>) -> Void) {
        CompetitionAPI.competitionGet { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
