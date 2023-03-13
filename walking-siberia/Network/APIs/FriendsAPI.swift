import Foundation
import Alamofire

class FriendsAPI {
    
    class func friendsGet(friendsRequest: FriendsRequest, completion: @escaping ((_ data: SuccessResponse<[User]>?,_ error: ErrorResponse?) -> Void)) {
        friendsGetWithRequestBuilder(friendsRequest: friendsRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsGetWithRequestBuilder(friendsRequest: FriendsRequest) -> RequestBuilder<SuccessResponse<[User]>> {
        let path = "/friends"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "filter": friendsRequest.filter,
            "search": friendsRequest.search,
            "limit": friendsRequest.limit,
            "page": friendsRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[User]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func friendsInvitesGet(friendsInvitesRequest: FriendsInvitesRequest, completion: @escaping ((_ data: SuccessResponse<[User]>?,_ error: ErrorResponse?) -> Void)) {
        friendsInvitesGetWithRequestBuilder(friendsInvitesRequest: friendsInvitesRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsInvitesGetWithRequestBuilder(friendsInvitesRequest: FriendsInvitesRequest) -> RequestBuilder<SuccessResponse<[User]>> {
        let path = "/friends-2"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "disabled": friendsInvitesRequest.disabled,
            "search": friendsInvitesRequest.search,
            "limit": friendsInvitesRequest.limit,
            "page": friendsInvitesRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[User]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func friendsSyncContactsPost(friendsSyncContactsRequest: [FriendsSyncContactsRequest],
                                       completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        friendsSyncContactsPostWithRequestBuilder(friendsSyncContactsRequest: friendsSyncContactsRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsSyncContactsPostWithRequestBuilder(friendsSyncContactsRequest: [FriendsSyncContactsRequest]) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/friends/sync-contacts"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: friendsSyncContactsRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func friendsViewUidGet(userId: Int, completion: @escaping ((_ data: SuccessResponse<User>?,_ error: ErrorResponse?) -> Void)) {
        friendsViewUidGetWithRequestBuilder(userId: userId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsViewUidGetWithRequestBuilder(userId: Int) -> RequestBuilder<SuccessResponse<User>> {
        var path = "/friends/view/{uid}"
        let routeIdPreEscape = "\(userId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<User>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func friendsAddPost(friendsAddRequest: FriendsAddRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        friendsAddPostWithRequestBuilder(friendsAddRequest: friendsAddRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsAddPostWithRequestBuilder(friendsAddRequest: FriendsAddRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/friends/add"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: friendsAddRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func friendsDeletePost(friendsDeleteRequest: FriendsDeleteRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        friendsDeletePostWithRequestBuilder(friendsDeleteRequest: friendsDeleteRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsDeletePostWithRequestBuilder(friendsDeleteRequest: FriendsDeleteRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/friends/delete"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: friendsDeleteRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func friendsWalkChartUidGet(userId: Int, completion: @escaping ((_ data: SuccessResponse<Statistic>?,_ error: ErrorResponse?) -> Void)) {
        friendsWalkChartUidGetWithRequestBuilder(userId: userId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func friendsWalkChartUidGetWithRequestBuilder(userId: Int) -> RequestBuilder<SuccessResponse<Statistic>> {
        var path = "/friends/walk-chart/{uid}"
        let routeIdPreEscape = "\(userId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Statistic>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
