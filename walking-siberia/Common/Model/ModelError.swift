import Foundation

struct DecodableError: Codable {
    let message: String
}

struct ModelError: Error {
    var err: ErrorResponse?

    func message() -> String {
        if case .error( _, let data?, _) = err {
            if let decodeError = CodableHelper.decode(SuccessResponse<DecodableError>.self, from: data).decodableObj,
               let message = decodeError.data?.message {
                return message
            }
            
            return "Неизвестная ошибка (не удалось декодировать ошибку)"
        }
        
        return "Не удалось декодировать ответ сервера"
    }

    var localizedDescription: String {
        return message()
    }
    
}
