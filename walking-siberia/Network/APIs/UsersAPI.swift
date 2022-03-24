import Foundation
import Alamofire

class UsersAPI {
    
    class func usersGet(usersRequest: UsersRequest, completion: @escaping ((_ data: SuccessResponse<[User]>?,_ error: ErrorResponse?) -> Void)) {
        usersGetWithRequestBuilder(usersRequest: usersRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func usersGetWithRequestBuilder(usersRequest: UsersRequest) -> RequestBuilder<SuccessResponse<[User]>> {
        let path = "/users"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "filter": usersRequest.filter,
            "search": usersRequest.search,
            "limit": usersRequest.limit,
            "page": usersRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[User]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
