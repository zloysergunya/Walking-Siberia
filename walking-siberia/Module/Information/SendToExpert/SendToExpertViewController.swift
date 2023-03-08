import UIKit

class SendToExpertViewController: ViewController<SendToExpertView> {
    
    private let expert: Expert
    private let provider = ExpertQAProvider()
    
    init(expert: Expert) {
        self.expert = expert
        super.init(nibName: nil, bundle: nil)
        
        title = "Задать вопрос"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
