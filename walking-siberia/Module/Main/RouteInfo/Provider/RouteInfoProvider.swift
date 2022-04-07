import Foundation

class RouteInfoProvider {
    
    func toggleLike(routeId: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        MapsAPI.mapsUidLikeGet(routeId: routeId) { response, error in
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
