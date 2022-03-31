//
//  KeyboardMonitor.swift
//  USpeak
//
//  Created by Кирилл on 11.01.2022.
//

import UIKit

class KeyboardMonitor {
    weak var observer: KeyboardObserver?
    var isOpen: Bool = false

    init() {
        subscribeOnKeyboardNotifications()
    }

    deinit {
        unsubscribeFromKeyboardNotifications()
    }

    private func subscribeOnKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboard),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboard),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboard),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboard),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func notificationKeyboard(notification: Foundation.Notification) {
        guard let userInfo: Dictionary = notification.userInfo,
            let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else { return }

        var keyboardEndFrame = endFrameValue.cgRectValue
        
        if let view = observer as? UIView {
            keyboardEndFrame = view.convert(keyboardEndFrame, from: nil)
        }
        
        if let viewController = observer as? UIViewController, let view = viewController.view {
            keyboardEndFrame = view.convert(keyboardEndFrame, from: nil)
        }
        
        let animationDuration: TimeInterval = durationValue.doubleValue
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(curveValue.uint32Value << 16))

        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            observer?.keyboardWillShowWithFrame(keyboardEndFrame,
                                                duration: animationDuration,
                                                options: [.beginFromCurrentState, animationCurve])
            
        case UIResponder.keyboardDidShowNotification:
            observer?.keyboardDidShowWithFrame(keyboardEndFrame)
            isOpen = true
            
        case UIResponder.keyboardWillHideNotification:
            observer?.keyboardWillHideWithFrame(keyboardEndFrame,
                                                duration: animationDuration,
                                                options: [.beginFromCurrentState, animationCurve])
            
        case UIResponder.keyboardDidHideNotification:
            observer?.keyboardDidHideWithFrame(keyboardEndFrame)
            isOpen = false
            
        default: break
        }
    }
}
