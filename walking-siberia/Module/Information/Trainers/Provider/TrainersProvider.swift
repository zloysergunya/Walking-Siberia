import Foundation

class TrainersProvider {
    
    func loadTrainers(completion: @escaping(Result<[Trainer], ModelError>) -> Void) {
        TrainersAPI.trainersGet { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
