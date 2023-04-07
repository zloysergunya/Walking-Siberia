import Foundation

final class CityDropDownProvider {
    func loadCities(completion: @escaping(Result<[RouteCity], ModelError>) -> Void) {
        CitiesAPI.citiesGet { response, error in
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
