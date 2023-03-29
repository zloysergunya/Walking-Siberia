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
            "name": teamsUidRequest.name,
            "disabled": teamsUidRequest.disabled,
            "limit": teamsUidRequest.limit,
            "page": teamsUidRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Team]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamsUidStatsGet(teamsUidRequest: TeamsUidRequest, completion: @escaping ((_ data: SuccessResponse<[Team]>?,_ error: ErrorResponse?) -> Void)) {
        teamsUidStatsGetWithRequestBuilder(teamsUidRequest: teamsUidRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamsUidStatsGetWithRequestBuilder(teamsUidRequest: TeamsUidRequest) -> RequestBuilder<SuccessResponse<[Team]>> {
        var path = "/teams/{uid}/stats"
        let routeIdPreEscape = "\(teamsUidRequest.uid)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "name": teamsUidRequest.name,
            "disabled": teamsUidRequest.disabled,
            "limit": teamsUidRequest.limit,
            "page": teamsUidRequest.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Team]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamCreatePost(teamCreateRequest: TeamCreateRequest, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        teamCreatePostWithRequestBuilder(teamCreateRequest: teamCreateRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamCreatePostWithRequestBuilder(teamCreateRequest: TeamCreateRequest) -> RequestBuilder<SuccessResponse<Team>> {
        let path = "/team/create"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamCreateRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func teamUpdatePost(teamUpdateRequest: TeamUpdateRequest, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        teamUpdatePostWithRequestBuilder(teamUpdateRequest: teamUpdateRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamUpdatePostWithRequestBuilder(teamUpdateRequest: TeamUpdateRequest) -> RequestBuilder<SuccessResponse<Team>> {
        let path = "/team/update"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamUpdateRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func teamDeletePost(teamDeleteRequest: TeamDeleteRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        teamDeletePostWithRequestBuilder(teamDeleteRequest: teamDeleteRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamDeletePostWithRequestBuilder(teamDeleteRequest: TeamDeleteRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/team/delete"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamDeleteRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func teamJoinPost(teamJoinRequest: TeamJoinRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        teamJoinPostWithRequestBuilder(teamJoinRequest: teamJoinRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamJoinPostWithRequestBuilder(teamJoinRequest: TeamJoinRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/team/join"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamJoinRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func teamLeavePost(teamLeaveRequest: TeamLeaveRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        teamLeavePostWithRequestBuilder(teamLeaveRequest: teamLeaveRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamLeavePostWithRequestBuilder(teamLeaveRequest: TeamLeaveRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/team/leave"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamLeaveRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func myteamUidGet(competitionId: Int, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        myteamUidGetWithRequestBuilder(competitionId: competitionId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func myteamUidGetWithRequestBuilder(competitionId: Int) -> RequestBuilder<SuccessResponse<Team>> {
        var path = "/my-team/{uid}"
        let routeIdPreEscape = "\(competitionId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamViewUidGet(teamId: Int, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        teamViewUidGetWithRequestBuilder(teamId: teamId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamViewUidGetWithRequestBuilder(teamId: Int) -> RequestBuilder<SuccessResponse<Team>> {
        var path = "/team/view/{uid}"
        let routeIdPreEscape = "\(teamId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamstatisticTeamGet(teamId: Int, competitionsId: Int, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        teamstatisticTeamGetWithRequestBuilder(teamId: teamId, competitionsId: competitionsId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamstatisticTeamGetWithRequestBuilder(teamId: Int, competitionsId: Int) -> RequestBuilder<SuccessResponse<Team>> {
        let path = "/team/statistic-team"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "teamId": teamId,
            "id": competitionsId
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamUidUsersGet(teamId: Int, teamUidUsers: TeamUidUsers, completion: @escaping ((_ data: SuccessResponse<[Participant]>?,_ error: ErrorResponse?) -> Void)) {
        teamUidUsersGetWithRequestBuilder(teamId: teamId, teamUidUsers: teamUidUsers).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamUidUsersGetWithRequestBuilder(teamId: Int, teamUidUsers: TeamUidUsers) -> RequestBuilder<SuccessResponse<[Participant]>> {
        var path = "/team/{uid}/users"
        let routeIdPreEscape = "\(teamId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "disabled": teamUidUsers.disabled,
            "limit": teamUidUsers.limit,
            "page": teamUidUsers.page
        ])

        let requestBuilder: RequestBuilder<SuccessResponse<[Participant]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamUidUsersCidStatsGet(teamId: Int, competitionsId: Int, teamUidUsers: TeamUidUsers, completion: @escaping ((_ data: SuccessResponse<[Participant]>?,_ error: ErrorResponse?) -> Void)) {
        teamUidUsersCidStatsGetWithRequestBuilder(teamId: teamId, competitionsId: competitionsId, teamUidUsers: teamUidUsers).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamUidUsersCidStatsGetWithRequestBuilder(teamId: Int, competitionsId: Int, teamUidUsers: TeamUidUsers) -> RequestBuilder<SuccessResponse<[Participant]>> {
        var path = "/team/{uid}/users/{cid}/stats"
        let routeIdPreEscape = "\(teamId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        
        let competitionsIdPreEscape = "\(competitionsId)"
        let competitionsIdPostEscape = competitionsIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{cid}", with: competitionsIdPostEscape, options: .literal, range: nil)
        
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "disabled": teamUidUsers.disabled,
            "limit": teamUidUsers.limit,
            "page": teamUidUsers.page
        ])
        
        let requestBuilder: RequestBuilder<SuccessResponse<[Participant]>>.Type = APIConfig.requestBuilderFactory.getBuilder()
        
        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func teamAddUserPost(teamAddUserRequest: TeamAddUserRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        teamAddUserPostWithRequestBuilder(teamAddUserRequest: teamAddUserRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamAddUserPostWithRequestBuilder(teamAddUserRequest: TeamAddUserRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/team/add-user"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamAddUserRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func teamDeleteUserPost(teamDeleteUserRequest: TeamDeleteUserRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        teamDeleteUserPostWithRequestBuilder(teamDeleteUserRequest: teamDeleteUserRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func teamDeleteUserPostWithRequestBuilder(teamDeleteUserRequest: TeamDeleteUserRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/team/delete-user"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: teamDeleteUserRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func userTeamGet(completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        userTeamGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func userTeamGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<Team>> {
        let path = "/user-team"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func userTeamByUserUidGet(id: Int, completion: @escaping ((_ data: SuccessResponse<Team>?,_ error: ErrorResponse?) -> Void)) {
        userTeamByUserUidGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func userTeamByUserUidGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<Team>> {
        var path = "/user-team-by-user/{uid}"
        let idPreEscape = "\(id)"
        let idPostEscape = idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: idPostEscape, options: .literal, range: nil)
        
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<SuccessResponse<Team>>.Type = APIConfig.requestBuilderFactory.getBuilder()
        
        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
