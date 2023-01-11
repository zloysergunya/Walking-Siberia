import Foundation
import Alamofire

class TrainersAPI {
    
    class func trainersGet(cityId: Int?, completion: @escaping ((_ data: SuccessResponse<[Trainer]>?,_ error: ErrorResponse?) -> Void)) {
        trainersGetWithRequestBuilder(cityId: cityId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func trainersGetWithRequestBuilder(cityId: Int?) -> RequestBuilder<SuccessResponse<[Trainer]>> {
        let path = "/trainers"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "cityId": cityId
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Trainer]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
