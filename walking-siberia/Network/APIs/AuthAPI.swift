import Foundation
import Alamofire

class AuthAPI {
    
    class func authApplePost(token: String, completion: @escaping ((_ data: AuthGoggleResponse?,_ error: ErrorResponse?) -> Void)) {
        authApplePostWithRequestBuilder(token: token).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func authApplePostWithRequestBuilder(token: String) -> RequestBuilder<AuthGoggleResponse> {
        let path = "/auth/apple"
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "apple_token": token
        ])

        let requestBuilder: RequestBuilder<AuthGoggleResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func authGooglePost(token: String, completion: @escaping ((_ data: AuthGoggleResponse?,_ error: ErrorResponse?) -> Void)) {
        authGooglePostWithRequestBuilder(token: token).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func authGooglePostWithRequestBuilder(token: String) -> RequestBuilder<AuthGoggleResponse> {
        let path = "/auth/google"
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "google_token": token
        ])

        let requestBuilder: RequestBuilder<AuthGoggleResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
