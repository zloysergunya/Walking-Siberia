import Foundation

final class ServiceLocator {
    
    private lazy var services: [String: Any] = [:]
    
    func add<T>(service: T) {
        let key = "\(T.self)"
        services[key] = service
    }

    func getService<T>() -> T? {
        let key = "\(T.self)"
        return services[key] as? T
    }
    
    func getAny<T>() -> T? {
        services.compactMap({ $0.value as? T }).first
    }
}

extension ServiceLocator {
    static let shared = ServiceLocator()
    
    static func getService<T>() -> T? {
        Self.shared.getService()
    }
    
    static func getAny<T>() -> T? {
        Self.shared.getAny()
    }
}
