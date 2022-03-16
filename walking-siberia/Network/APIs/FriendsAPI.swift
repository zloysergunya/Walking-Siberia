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
            "limit": friendsRequest.limit,
            "page": friendsRequest.page
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
    
}
