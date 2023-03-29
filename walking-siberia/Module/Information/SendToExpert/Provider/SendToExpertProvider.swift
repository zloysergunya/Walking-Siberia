import Foundation

final class SendToExpertProvider {
    func sendQuestion(id: Int, text: String, completion: @escaping(Result<EmptyData?, ModelError>) -> Void) {
        let expertsQuestionPostRequest = ExpertsQuestionPostRequest(expertId: id, question: text)
        ExpertsAPI.expertsQuestionPost(expertsQuestionPostRequest: expertsQuestionPostRequest) { response, error in
            if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.success(response?.data))
            }
        }
    }
}
