import Foundation

class DeepLinkProvider {
    
    func loadRoute(id: Int, completion: @escaping(Result<Route, ModelError>) -> Void) {
        MapsAPI.mapsUidGet(id: id) { response, error in
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
    
    func loadArticle(id: Int, completion: @escaping(Result<Article, ModelError>) -> Void) {
        ArticleAPI.articleUidGet(id: id) { response, error in
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
    
    func loadVideo(id: Int, completion: @escaping(Result<Video, ModelError>) -> Void) {
        VideosAPI.videosUidGet(id: id) { response, error in
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
    
    func loadСompetition(id: Int, completion: @escaping(Result<Competition, ModelError>) -> Void) {
        CompetitionAPI.competitionUidGet(competitionId: id) { response, error in
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
