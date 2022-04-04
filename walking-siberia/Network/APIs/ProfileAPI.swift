import Foundation
import Alamofire

class ProfileAPI {
    
    class func profileGet(completion: @escaping ((_ data: SuccessResponse<User>?,_ error: ErrorResponse?) -> Void)) {
        profileGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<User>> {
        let path = "/profile"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<User>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func profileUpdatePost(profileUpdate: ProfileUpdateRequest, completion: @escaping ((_ data: SuccessResponse<User>?,_ error: ErrorResponse?) -> Void)) {
        profileUpdatePostWithRequestBuilder(profileUpdate: profileUpdate).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileUpdatePostWithRequestBuilder(profileUpdate: ProfileUpdateRequest) -> RequestBuilder<SuccessResponse<User>> {
        let path = "/profile/update"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: profileUpdate)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<User>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func profileAvatarPost(photo: URL? = nil, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        profileAvatarPostWithRequestBuilder(photo: photo).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileAvatarPostWithRequestBuilder(photo: URL?) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/profile/avatar"
        let URLString = APIConfig.basePath + path
        let formParams: [String:Any?] = [
            "avatarFile": photo
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func profileStatisticsGet(completion: @escaping ((_ data: SuccessResponse<Statistic>?,_ error: ErrorResponse?) -> Void)) {
        profileStatisticsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileStatisticsGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<Statistic>> {
        let path = "/profile/statistics"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<Statistic>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func profileAvatarDeleteGet(completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        profileAvatarDeleteGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileAvatarDeleteGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/profile/avatar/delete"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func profileDevicePost(profileDevice: ProfileDeviceRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        profileDevicePostWithRequestBuilder(profileDevice: profileDevice).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileDevicePostWithRequestBuilder(profileDevice: ProfileDeviceRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/profile/device"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: profileDevice)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func profileNoticeTypeGet(type: String, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        profileNoticeTypeGetWithRequestBuilder(type: type).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func profileNoticeTypeGetWithRequestBuilder(type: String) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/profile/notice/{type}"
        let routeIdPreEscape = type
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{type}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
