import Foundation

class RoutesProvider {
    
    func routes(cityId: Int?, completion: @escaping(Result<[Route], ModelError>) -> Void) {
        MapsAPI.mapsGet(cityId: cityId) { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func syncContacts(contacts: [Contact], completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        let friendsSyncContactsRequest = contacts.map({ FriendsSyncContactsRequest(phone: $0.phone, name: $0.name) })
        FriendsAPI.friendsSyncContactsPost(friendsSyncContactsRequest: friendsSyncContactsRequest) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func sendPushToken(token: String, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        ProfileAPI.profileDevicePost(profileDevice: ProfileDeviceRequest(deviceId: token)) { response, error in
            if let response = response {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func updateCountNewNotifications(completion: @escaping(Result<Int, ModelError>) -> Void) {
        NotificationAPI.notificationCountNewGet { response, error in
            if let response = response?.data {
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
}
