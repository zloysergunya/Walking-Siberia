import Foundation
import Alamofire

class CitiesAPI {
    
    class func citiesGet(completion: @escaping ((_ data: SuccessResponse<[RouteCity]>?,_ error: ErrorResponse?) -> Void)) {
        citiesGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func citiesGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[RouteCity]>> {
        let path = "/cities"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[RouteCity]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
