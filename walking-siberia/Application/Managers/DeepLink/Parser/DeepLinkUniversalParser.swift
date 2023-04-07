import Foundation

class DeepLinkUniversalParser {
    
    init(){}
    
    func parse(_ url: URL) -> DeepLink? {
        if let host = url.host,
           let type = DeepLinkType(rawValue: host),
           let id = Int(url.lastPathComponent) {
            
            return DeepLink(id: id, type: type)
        }
        
        return nil
    }
    
}
