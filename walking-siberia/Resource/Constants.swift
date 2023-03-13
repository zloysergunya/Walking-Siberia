import Foundation
import UIKit

enum Constants {

    // MARK: - API
    static let apiVersion = 2
    static let pageLimit = 20
    static var prodUrl: String { "https://api.walking-siberia.ru/v\(apiVersion)" }
    static var devUrl: String { "http://194.67.126.180:8005/v\(apiVersion)" }
    static var basePath: String { UserSettings.isDev ? devUrl: prodUrl }
    
    static let appStoreId = ""
    static let bundleIdentifier = Bundle.current.bundleIdentifier ?? "ru.abs.walking-siberia"
    static let agreementUrl = "https://walking-siberia.ru/site/agreement"
    static var deepLinkPath: String { "walkingsiberia://" }

    static var releaseVersion: String { Bundle.current.releaseVersionNumber ?? "0.0.0" }
    static var buildNumber: String { Bundle.current.buildVersionNumber ?? "0" }
    static var appVersion: String { "\(releaseVersion) (\(buildNumber))" }
    static var deviceModelName: String { UIDevice.modelName.replacingOccurrences(of: " ", with: "_", options: .literal) }
    
    static var userAgent: String? = {
        if let lang = Locale.current.languageCode {

            // {Api version} {platform}/{version}/{build} {language} {device} 1 ios/1.0/1 en iPhone12,1
            return "\(apiVersion) ios/\(releaseVersion)/\(buildNumber) \(lang) \(deviceModelName)"
        }

        return nil
    }()
}
