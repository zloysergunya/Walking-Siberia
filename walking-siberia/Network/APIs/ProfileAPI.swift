import Foundation
import Alamofire

class ProfileAPI {
    
    class func profileUpdatePost(profileUpdate: ProfileUpdateRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        profileUpdatePostWithRequestBuilder(profileUpdate: profileUpdate).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileUpdatePostWithRequestBuilder(profileUpdate: ProfileUpdateRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/profile/update"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: profileUpdate)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
