import Foundation

class AddReviewProvider {

    func sendReview(routeId: Int, text: String, completion: @escaping(Result<EmptyData, ModelError>) -> Void) {
        let mapsCommentRequest = MapsCommentRequest(routeId: routeId, text: text)
        MapsAPI.mapsCommentPost(mapsCommentRequest: mapsCommentRequest) { response, error in
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
