import Foundation

class MapsAPI {
    
    class func mapsGet(completion: @escaping ((_ data: SuccessResponse<[Route]>?,_ error: ErrorResponse?) -> Void)) {
        mapsGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func mapsGetWithRequestBuilder() -> RequestBuilder<SuccessResponse<[Route]>> {
        let path = "/maps"
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<SuccessResponse<[Route]>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func mapsUidLikeGet(routeId: Int, completion: @escaping ((_ data: SuccessResponse<EmptyData>?,_ error: ErrorResponse?) -> Void)) {
        mapsUidLikeGetWithRequestBuilder(routeId: routeId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }
    
    private class func mapsUidLikeGetWithRequestBuilder(routeId: Int) -> RequestBuilder<SuccessResponse<EmptyData>> {
        var path = "/maps/{uid}/like"
        let routeIdPreEscape = "\(routeId)"
        let routeIdPostEscape = routeIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{uid}", with: routeIdPostEscape, options: .literal, range: nil)
        let URLString = APIConfig.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<SuccessResponse<EmptyData>>.Type = APIConfig.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}