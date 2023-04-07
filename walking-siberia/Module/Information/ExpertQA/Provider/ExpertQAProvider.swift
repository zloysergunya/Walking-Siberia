import Foundation

final class ExpertQAProvider {
    func loadQuestions(id: Int, completion: @escaping(Result<[ExpertQuestion], ModelError>) -> Void) {
        ExpertsAPI.expertsQuestionsUidGet(id: id) { response, error in
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
