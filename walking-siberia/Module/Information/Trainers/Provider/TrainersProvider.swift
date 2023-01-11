import Foundation

class TrainersProvider {
    
    func loadTrainers(cityId: Int?, completion: @escaping(Result<[Trainer], ModelError>) -> Void) {
        TrainersAPI.trainersGet(cityId: cityId) { response, error in
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
