import Foundation

class NotificationsProvider {
    
    var page: Int = 1
    
    func loadNotifications(filter: String, completion: @escaping(Result<[Notification], ModelError>) -> Void) {
        let notificationListRequest = NotificationListRequest(filter: filter, limit: Constants.pageLimit, page: page)
        NotificationAPI.notificationListGet(notificationListRequest: notificationListRequest) { [weak self] response, error in
            guard let self = self else { return }
            if let response = response?.data {
                self.page = response.isEmpty ? -1 : self.page + 1
                completion(.success(response))
            } else if let error = error {
                log.error(ModelError(err: error).message())
                completion(.failure(ModelError(err: error)))
            } else {
                completion(.failure(ModelError()))
            }
        }
    }
    
    func readNotification(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        NotificationAPI.notificationViewGet(id: id) { response, error in
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
    
    func hideNotification(id: Int, completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        NotificationAPI.notificationHideGet(id: id) { response, error in
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
    
    func clearAll(completion: @escaping(Result<SuccessResponse<EmptyData>, ModelError>) -> Void) {
        NotificationAPI.notificationClearGet { response, error in
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
    
}
