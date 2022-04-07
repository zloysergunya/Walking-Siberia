import Foundation

class UserStatisticProvider {
        
    func loadWalkChart(userId: Int, completion: @escaping(Result<Statistic, ModelError>) -> Void) {
        FriendsAPI.friendsWalkChartUidGet(userId: userId) { response, error in
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
