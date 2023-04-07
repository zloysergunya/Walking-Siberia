import Foundation
import Alamofire

class ArticleAPI {
    
    class func articleGet(articleRequest: ArticleRequest, completion: @escaping ((_ data: SuccessResponse<[Article]>?,_ error: ErrorResponse?) -> Void)) {
        articleGetWithRequestBuilder(articleRequest: articleRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func articleGetWithRequestBuilder(articleRequest: ArticleRequest) -> RequestBuilder<SuccessResponse<[Article]>> {
        let path = "/article"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "limit": articleRequest.limit,
            "page": articleRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Article]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func articleAddViewIdGet(id: Int, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        articleAddViewIdGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func articleAddViewIdGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/article/add-view/{id}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func articleUidGet(id: Int, completion: @escaping ((_ data: SuccessResponse<Article>?,_ error: ErrorResponse?) -> Void)) {
        articleUidGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func articleUidGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<Article>> {
        var path = "/article/{uid}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Article>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
