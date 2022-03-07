import Foundation
import Alamofire

class CompetitionAPI {
    
    class func competitionGet(completion: @escaping ((_ data: SuccessResponse<[Competition]>?,_ error: ErrorResponse?) -> Void)) {
        competitionGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func competitionGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Competition]>> {
        let path = "/competitions"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Competition]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
