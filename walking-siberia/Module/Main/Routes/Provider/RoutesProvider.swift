import Foundation

class RoutesProvider {
    
    func routes(completion: @escaping(Result<SuccessResponse<[Route]>, ModelError>) -> Void) {
        MapsAPI.mapsGet { response, error in
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
