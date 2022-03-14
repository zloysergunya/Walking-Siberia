import UIKit

extension UIViewController {
    
    func showError(text: String, cancelText: String = "Ок", onCancel: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: onCancel))
        
        present(alert, animated: true)
    }
    
}
