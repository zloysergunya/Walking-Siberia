import Foundation

final class ExpertsProvider {
    func loadExperts(completion: @escaping(Result<[Expert], ModelError>) -> Void) {
        ExpertsAPI.expertsGet() { response, error in
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
