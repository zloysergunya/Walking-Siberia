import Foundation
import Alamofire

class TrainersAPI {
    
    class func trainersGet(completion: @escaping ((_ data: SuccessResponse<[Trainer]>?,_ error: ErrorResponse?) -> Void)) {
        trainersGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func trainersGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Trainer]>> {
        let path = "/trainers"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Trainer]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
