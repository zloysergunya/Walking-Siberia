import Foundation

class TeamsProvider {
    
    var page: Int = 1
    
    func loadTeams(uid: Int, filter: String, completion: @escaping(Result<[Team], Error>) -> Void) {
        let teamsUidRequest = TeamsUidRequest(uid: uid, filter: filter, limit: Constants.pageLimit, page: page)
        TeamsAPI.teamsUidGet(teamsUidRequest: teamsUidRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
                
                completion(.success(response))
            } else if let error = error {
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
