import Foundation
import UIKit

enum Constants {

    static let pageLimit = 20
    
    static let appStoreId = ""
    static let bundleIdentifier = Bundle.current.bundleIdentifier ?? "ru.abs.walking-siberia"
    static let agreementUrl = "https://walking-siberia.ru/site/agreement"

    static var releaseVersion: String { Bundle.current.releaseVersionNumber ?? "0.0.0" }
    static var buildNumber: String { Bundle.current.buildVersionNumber ?? "0" }
    static var appVersion: String { "\(releaseVersion) (\(buildNumber))" }
    static var deviceModelName: String { UIDevice.modelName.replacingOccurrences(of: " ", with: "_", options: .literal) }
    
    static var userAgent: String? = {
        if let lang = Locale.current.languageCode {

            // {Api version} {platform}/{version}/{build} {language} {device} 1 ios/1.0/1 en iPhone12,1
            return "\(APIConfig.apiVersion) ios/\(Constants.releaseVersion)/\(Constants.buildNumber) \(lang) \(deviceModelName)"
        }

        return nil
    }()
}
