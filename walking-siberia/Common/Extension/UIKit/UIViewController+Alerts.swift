import UIKit

extension UIViewController {
    
    func showError(text: String, cancelText: String = "Ок", onCancel: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: onCancel))
        
        present(alert, animated: true)
    }
    
    func dialog(title: String,
                message: String = "",
                accessText: String? = nil,
                cancelText: String? = "Закрыть",
                onAgree: ((UIAlertAction) -> Void)? = nil,
                onCancel: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let accessText = accessText {
            alert.addAction(UIAlertAction(title: accessText, style: .default, handler: onAgree))
        }
        if let cancelText = cancelText {
            alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: onCancel))
        }
        
        present(alert, animated: true)
    }
    
}
