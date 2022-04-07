import Foundation

class HealthServiceProvider {
    
    func sendUserActivity(walkRequest: WalkRequest, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        WalkAPI.walkPut(walkRequest: walkRequest) { response, error in
            if let response = response {
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
