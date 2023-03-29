import Foundation
import Alamofire

class AchievementAPI {
    
    class func achievementGet(completion: @escaping ((_ data: SuccessResponse<[Achievement]>?,_ error: ErrorResponse?) -> Void)) {
        achievementGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func achievementGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Achievement]>> {
        let path = "/achievement"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Achievement]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func achievementTeamUidGet(id: Int, completion: @escaping ((_ data: SuccessResponse<[Achievement]>?,_ error: ErrorResponse?) -> Void)) {
        achievementTeamUidGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func achievementTeamUidGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<[Achievement]>> {
        var path = "/achievement/user/{uid}"
        let uidPreEscape = "\(id)"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Achievement]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
