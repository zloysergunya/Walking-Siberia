import Foundation
import Alamofire

class VideosAPI {
    
    class func videosGet(videosRequest: VideosRequest, completion: @escaping ((_ data: SuccessResponse<[Video]>?,_ error: ErrorResponse?) -> Void)) {
        videosGetWithRequestBuilder(videosRequest: videosRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func videosGetWithRequestBuilder(videosRequest: VideosRequest) -> RequestBuilder<SuccessResponse<[Video]>> {
        let path = "/videos"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "limit": videosRequest.limit,
            "page": videosRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Video]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func videosAddViewIdGet(id: Int, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        videosAddViewIdGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func videosAddViewIdGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/videos/add-view/{id}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func videosUidGet(id: Int, completion: @escaping ((_ data: SuccessResponse<Video>?,_ error: ErrorResponse?) -> Void)) {
        videosUidGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func videosUidGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<Video>> {
        var path = "/videos/{uid}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Video>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
