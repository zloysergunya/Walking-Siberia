import Foundation

class VideosProvider {
    
    var page: Int = 1
    
    func loadVideos(completion: @escaping(Result<[Video], ModelError>) -> Void) {
        let videosRequest = VideosRequest(limit: Constants.pageLimit, page: page)
        VideosAPI.videosGet(videosRequest: videosRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func addViewTo(videoId: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        VideosAPI.videosAddViewIdGet(id: videoId) { response, error in
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
