import Foundation

extension Bundle {
    
    var version: String {
        if let info = infoDictionary, let shortVersion = info["CFBundleShortVersionString"] as? String,
           let bundleVersion = info["CFBundleVersion"] as? String {
            return shortVersion + "." + bundleVersion
        } else {
            return "unknown"
        }
    }
    
    var releaseVersionNumber: String! { infoDictionary?["CFBundleShortVersionString"] as? String }
    var buildVersionNumber: String! { infoDictionary?["CFBundleVersion"] as? String }
    
}
