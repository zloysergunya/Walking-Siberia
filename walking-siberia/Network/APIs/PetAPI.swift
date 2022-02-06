import Foundation
import Alamofire

class PetAPI {
    
    class func petGet(free: Bool?, myPets: Bool?, completion: @escaping ((_ data: PetResponse?,_ error: ErrorResponse?) -> Void)) {
        petGetWithRequestBuilder(free: free, myPets: myPets).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func petGetWithRequestBuilder(free: Bool?, myPets: Bool?) -> RequestBuilder<PetResponse> {
        let path = "/pet"
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "free": free,
            "my_pets": myPets
        ])

        let requestBuilder: RequestBuilder<PetResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func petDownloads(completion: @escaping ((_ data: [PetAnimation]?,_ error: ErrorResponse?) -> Void)) {
        petDownloadsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func petDownloadsWithRequestBuilder() -> RequestBuilder<[PetAnimation]> {
        let path = "/pet/downloads"
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<[PetAnimation]>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
    class func petRandomName(completion: @escaping ((_ data: PetRandomNameResponse?,_ error: ErrorResponse?) -> Void)) {
        petRandomNameWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    private class func petRandomNameWithRequestBuilder() -> RequestBuilder<PetRandomNameResponse> {
        let path = "/pet/random/name"
        let URLString = iPetAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        
        let requestBuilder: RequestBuilder<PetRandomNameResponse>.Type = iPetAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
    
}
