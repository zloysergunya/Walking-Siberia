import Foundation

class CompetitionInfoProvider {
    
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
    
}
