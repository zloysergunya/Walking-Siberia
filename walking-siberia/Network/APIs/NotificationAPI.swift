import Foundation
import Alamofire

class NotificationAPI {
 
    class func notificationListGet(notificationListRequest: NotificationListRequest,
                                   completion: @escaping ((_ data: SuccessResponse<[Notification]>?,_ error: ErrorResponse?) -> Void)) {
        notificationListGetWithRequestBuilder(notificationListRequest: notificationListRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func notificationListGetWithRequestBuilder(notificationListRequest: NotificationListRequest) -> RequestBuilder<SuccessResponse<[Notification]>> {
        let path = "/notification/list"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "filter": notificationListRequest.filter,
            "limit": notificationListRequest.limit,
            "page": notificationListRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Notification]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func notificationViewGet(id: Int, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        notificationViewGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func notificationViewGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/notification/view/{id}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func notificationHideGet(id: Int, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        notificationHideGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func notificationHideGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/notification/hide/{id}"
        let routeIdPreEscape = "\(id)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func notificationCountNewGet(completion: @escaping ((_ data: SuccessResponse<Int>?,_ error: ErrorResponse?) -> Void)) {
        notificationCountNewGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func notificationCountNewGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<Int>> {
        let path = "/notification/count-new"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Int>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func notificationClearGet(completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        notificationClearGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func notificationClearGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/notification/clear"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()
        
        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
