import Foundation
import Alamofire

class AuthAPI {
    
    class func authPost(auth: AuthRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        authPostWithRequestBuilder(auth: auth).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func authPostWithRequestBuilder(auth: AuthRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/auth"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: auth)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func authConfirmPost(authConfirm: AuthConfirmRequest, completion: @escaping ((_ data: SuccessResponse<AuthConfirmResponse>?,_ error: ErrorResponse?) -> Void)) {
        authConfirmPostWithRequestBuilder(authConfirm: authConfirm).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func authConfirmPostWithRequestBuilder(authConfirm: AuthConfirmRequest) -> RequestBuilder<SuccessResponse<AuthConfirmResponse>> {
        let path = "/auth/confirm"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: authConfirm)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<AuthConfirmResponse>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
