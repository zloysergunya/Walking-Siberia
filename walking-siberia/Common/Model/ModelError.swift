import Foundation

struct DecodableError: Codable {
    let message: String
}

struct ModelError: Error {
    var err: ErrorResponse?
    var text: String?
    
    init() {
        
    }
    
    init(err: ErrorResponse?) {
        self.err = err
    }
    
    init(text: String) {
        self.text = text
    }

    func message() -> String {
        if let text = text {
            return text
        }
        
        if case .error(let status, let data?, let error) = err {
            if let decodeError = CodableHelper.decode(SuccessResponse<DecodableError>.self, from: data).decodableObj,
               let message = decodeError.data?.message, !message.isEmpty {
                return message
            }
            
            log.error("Ошибка \(status): \(String(describing: error))")
            
            let message = "Ошибка \(status): "
            switch status {
            case 401:
                let authService: AuthService? = ServiceLocator.getService()
                authService?.deauthorize()
                
                return message + "Ошибка авторизации. Пожалуйста, войдите в свой аккаунт заново"
                
            case 403: return message + "Доступ запрещён"
            case 404: return message + "Данные не найдены"
            case 400...499: return message + "Ошибка в запросе на сервер"
            case 1000: return message + "Проверьте доступ к интернету"
            default: return message + "Пожалуйста, перезагрузите страницу"
            }
        }
        
        return "Не удалось декодировать ответ сервера"
    }

    var localizedDescription: String {
        return message()
    }
    
}
