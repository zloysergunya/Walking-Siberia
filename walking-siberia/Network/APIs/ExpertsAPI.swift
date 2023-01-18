import Foundation
import Alamofire

class ExpertsAPI {
    
    class func expertsGet(completion: @escaping ((_ data: SuccessResponse<[Expert]>?,_ error: ErrorResponse?) -> Void)) {
        expertsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func expertsGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Expert]>> {
        let path = "/experts"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Expert]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
