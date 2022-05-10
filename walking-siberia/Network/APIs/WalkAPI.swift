import Foundation
import Alamofire

class WalkAPI {
    
    class func walkPut(walkRequest: WalkRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        walkPutWithRequestBuilder(walkRequest: walkRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func walkPutWithRequestBuilder(walkRequest: WalkRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/walk"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: walkRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
