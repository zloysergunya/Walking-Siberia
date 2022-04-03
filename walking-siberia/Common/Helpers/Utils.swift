import UIKit
import CoreMotion
import AVFoundation

enum Utils {
    
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isRelease: Bool {
        #if RELEASE
            return true
        #else
            return false
        #endif
    }

    static var isAppStore: Bool {
        #if APPSTORE
            return true
        #else
            return false
        #endif
    }
    
    static func impact() {
        UIImpactFeedbackGenerator().impactOccurred(intensity: 0.7)
    }
    
}
