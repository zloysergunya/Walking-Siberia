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
    
    class func myCompetitionsGet(completion: @escaping ((_ data: SuccessResponse<[Competition]>?,_ error: ErrorResponse?) -> Void)) {
        myCompetitionsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func myCompetitionsGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Competition]>> {
        let path = "/my-competitions"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Competition]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
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
    
    class func competitionTeamJoinPost(competitionTeamJoinRequest: CompetitionTeamJoinRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        competitionTeamJoinPostWithRequestBuilder(competitionTeamJoinRequest: competitionTeamJoinRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func competitionTeamJoinPostWithRequestBuilder(competitionTeamJoinRequest: CompetitionTeamJoinRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/competition-team/join"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: competitionTeamJoinRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func competitionTeamLeavePost(competitionTeamLeaveRequest: CompetitionTeamLeaveRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        competitionTeamLeavePostWithRequestBuilder(competitionTeamLeaveRequest: competitionTeamLeaveRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func competitionTeamLeavePostWithRequestBuilder(competitionTeamLeaveRequest: CompetitionTeamLeaveRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/competition-team/leave"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: competitionTeamLeaveRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
