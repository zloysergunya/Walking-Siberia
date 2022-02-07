import UIKit

class ViewController<View: RootView>: UIViewController {
    
    lazy var keyboardMonitor = KeyboardMonitor()
    
    var automaticKeyboardObserverControl: Bool { true }
        
    var mainView: View! {
        view as? View
    }
    
    public override func loadView() {
        self.view = View()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let self = self as? KeyboardObserver {
            keyboardMonitor.observer = self
        }
        
        mainView.didLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.willAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainView.willDisappear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let self = self as? KeyboardObserver, automaticKeyboardObserverControl {
            keyboardMonitor.observer = self
        }
        
        mainView.didAppear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self is KeyboardObserver, automaticKeyboardObserverControl {
            keyboardMonitor.observer = nil
        }
        
        mainView.didDisappear()
    }
    
}
