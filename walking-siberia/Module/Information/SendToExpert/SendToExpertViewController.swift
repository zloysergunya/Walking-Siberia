import UIKit

final class SendToExpertViewController: ViewController<SendToExpertView> {
    
    private let expert: Expert
    private let provider = SendToExpertProvider()
    
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
        
        mainView.sendButton.addTarget(self, action: #selector(sendQuestion), for: .touchUpInside)
        
        mainView.textView.delegate = self
    }
    
    private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendQuestion() {
        mainView.sendButton.isLoading = true
        provider.sendQuestion(id: expert.id, text: mainView.textView.text) { [weak self] result in
            
            self?.mainView.sendButton.isLoading = false
            
            switch result {
            case .success:
                self?.dialog(title: "Ваш вопрос отправлен эксперту", message: "", onCancel: { _ in
                    self?.close()
                })
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension SendToExpertViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mainView.sendButton.isActive = !textView.text.isEmpty
    }
}
