import Foundation

struct DecodableError: Codable {
    let message: String
}

struct ModelError: Error {
    var err: ErrorResponse?

    func message() -> String {
        if case .error(let status, let data?, _) = err {
            if let decodeError = CodableHelper.decode(SuccessResponse<DecodableError>.self, from: data).decodableObj,
               let message = decodeError.data?.message {
                return message
            }
            
            let message = "Ошибка \(status): "
            switch status {
            case 401, 403: return message + "Доступ запрещён"
            case 404: return message + "Данные не найдены"
            case 400...499: return message + "Ошибка в запросе на сервер"
            case 500...599: return message + "Ошибка сервера"
            case 1000: return message + "Проверьте доступ к интернету"
            default: return message + "Неизвестная ошибка (не удалось декодировать ошибку)"
            }
        }
        
        return "Не удалось декодировать ответ сервера"
    }

    var localizedDescription: String {
        return message()
    }
    
}
