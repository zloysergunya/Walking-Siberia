import Foundation
import Alamofire

class TeamsAPI {
    
    class func teamsGet(teamsRequest: TeamsRequest, completion: @escaping ((_ data: SuccessResponse<[Team]>?,_ error: ErrorResponse?) -> Void)) {
        teamsGetWithRequestBuilder(teamsRequest: teamsRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamsGetWithRequestBuilder(teamsRequest: TeamsRequest) -> RequestBuilder<SuccessResponse<[Team]>> {
        let path = "/teams"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "filter": teamsRequest.filter,
            "limit": teamsRequest.limit,
            "page": teamsRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Team]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamsUidGet(teamsUidRequest: TeamsUidRequest, completion: @escaping ((_ data: SuccessResponse<[Team]>?,_ error: ErrorResponse?) -> Void)) {
        teamsUidGetWithRequestBuilder(teamsUidRequest: teamsUidRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamsUidGetWithRequestBuilder(teamsUidRequest: TeamsUidRequest) -> RequestBuilder<SuccessResponse<[Team]>> {
        var path = "/teams/{uid}"
        let routeIdPreEscape = "\(teamsUidRequest.uid)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "filter": teamsUidRequest.filter,
            "limit": teamsUidRequest.limit,
            "page": teamsUidRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Team]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
