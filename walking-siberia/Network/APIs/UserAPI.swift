import Foundation
import Alamofire

class UserAPI {
    
    class func userCheckUsernamePost(username: UserCheckUsernameRequest, completion: @escaping ((_ data: UserCheckUsernameResponse?,_ error: ErrorResponse?) -> Void)) {
        userCheckUsernamePostWithRequestBuilder(username: username).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userCheckUsernamePostWithRequestBuilder(username: UserCheckUsernameRequest) -> RequestBuilder<UserCheckUsernameResponse> {
        let path = "/user/check/username"
        let URLString = iPetAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: username)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UserCheckUsernameResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    class func userUsernameTranslitPost(name: UserUsernameTranslitRequest, completion: @escaping ((_ data: UserUsernameTranslitResponse?,_ error: ErrorResponse?) -> Void)) {
        userUsernameTranslitPostWithRequestBuilder(name: name).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userUsernameTranslitPostWithRequestBuilder(name: UserUsernameTranslitRequest) -> RequestBuilder<UserUsernameTranslitResponse> {
        let path = "/user/username/translit"
        let URLString = iPetAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: name)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UserUsernameTranslitResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func userMePatch(userMe: UserMeRequest, completion: @escaping ((_ data: User?,_ error: ErrorResponse?) -> Void)) {
        userMePatchWithRequestBuilder(userMe: userMe).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userMePatchWithRequestBuilder(userMe: UserMeRequest) -> RequestBuilder<User> {
        let path = "/user/me"
        let URLString = iPetAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: userMe)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func userAvatarPost(photo: URL? = nil, completion: @escaping ((_ data: UserAvatarResponse?,_ error: ErrorResponse?) -> Void)) {
        userAvatarPostWithRequestBuilder(photo: photo).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userAvatarPostWithRequestBuilder(photo: URL? = nil) -> RequestBuilder<UserAvatarResponse> {
        let path = "/user/avatar"
        let URLString = iPetAPI.basePath + path
        let formParams: [String:Any?] = [
            "image": photo
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<UserAvatarResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func userPetChoicePetIdPatch(petId: Int, completion: @escaping ((_ data: OkResponse?,_ error: ErrorResponse?) -> Void)) {
        userPetChoicePetIdPatchWithRequestBuilder(petId: petId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userPetChoicePetIdPatchWithRequestBuilder(petId: Int) -> RequestBuilder<OkResponse> {
        var path = "/user/pet/choice/{pet_id}"
        let _idPreEscape = "\(petId)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{pet_id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<OkResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func userPetUserPetIdPatch(userPetId: Int, userPetUserPetIdRequest: UserPetUserPetIdRequest, completion: @escaping ((_ data: OkResponse?,_ error: ErrorResponse?) -> Void)) {
        userPetUserPetIdPatchWithRequestBuilder(userPetId: userPetId, userPetUserPetIdRequest: userPetUserPetIdRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func userPetUserPetIdPatchWithRequestBuilder(userPetId: Int, userPetUserPetIdRequest: UserPetUserPetIdRequest) -> RequestBuilder<OkResponse> {
        var path = "/user/pet/{user_pet_id}"
        let _idPreEscape = "\(userPetId)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{user_pet_id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = iPetAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: userPetUserPetIdRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<OkResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PATCH", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
