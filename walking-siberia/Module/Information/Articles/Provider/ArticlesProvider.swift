import Foundation

class ArticlesProvider {
    
    var page: Int = 1
    
    func loadArticles(completion: @escaping(Result<[Article], ModelError>) -> Void) {
        let articleRequest = ArticleRequest(limit: Constants.pageLimit, page: page)
        ArticleAPI.articleGet(articleRequest: articleRequest) { [weak self] response, error in
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
    
    func addViewTo(articleId: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        ArticleAPI.articleAddViewIdGet(id: articleId) { response, error in
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
