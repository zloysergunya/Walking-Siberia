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
    
    class func competitionsUserUidGet(userId: Int, completion: @escaping ((_ data: SuccessResponse<[Competition]>?,_ error: ErrorResponse?) -> Void)) {
        competitionsUserUidGetWithRequestBuilder(userId: userId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func competitionsUserUidGetWithRequestBuilder(userId: Int) -> RequestBuilder<SuccessResponse<[Competition]>> {
        var path = "/competitions/user/{uid}"
        let routeIdPreEscape = "\(userId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Competition]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func competitionUidGet(competitionId: Int, completion: @escaping ((_ data: SuccessResponse<Competition>?,_ error: ErrorResponse?) -> Void)) {
        competitionUidGetWithRequestBuilder(competitionId: competitionId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func competitionUidGetWithRequestBuilder(competitionId: Int) -> RequestBuilder<SuccessResponse<Competition>> {
        var path = "/competition/{uid}"
        let routeIdPreEscape = "\(competitionId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Competition>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
