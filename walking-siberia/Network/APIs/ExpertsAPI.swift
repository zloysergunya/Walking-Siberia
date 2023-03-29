import Foundation
import Alamofire

class ExpertsAPI {
    
    class func expertsGet(completion: @escaping ((_ data: SuccessResponse<[Expert]>?,_ error: ErrorResponse?) -> Void)) {
        expertsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func expertsGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Expert]>> {
        let path = "/experts"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[Expert]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
    class func expertsQuestionsUidGet(id: Int, completion: @escaping ((_ data: SuccessResponse<[ExpertQuestion]>?,_ error: ErrorResponse?) -> Void)) {
        expertsQuestionsUidGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func expertsQuestionsUidGetWithRequestBuilder(id: Int) -> RequestBuilder<SuccessResponse<[ExpertQuestion]>> {
        var path = "/experts/questions/{uid}"
        let uidPreEscape = "\(id)"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<[ExpertQuestion]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func expertsQuestionPost(expertsQuestionPostRequest: ExpertsQuestionPostRequest, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        expertsQuestionPostWithRequestBuilder(expertsQuestionPostRequest: expertsQuestionPostRequest).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func expertsQuestionPostWithRequestBuilder(expertsQuestionPostRequest: ExpertsQuestionPostRequest) -> RequestBuilder<SuccessResponse<EmptyData>> {
        let path = "/experts/question"
        let URLString = APIConfig.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: expertsQuestionPostRequest)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }
    
}
