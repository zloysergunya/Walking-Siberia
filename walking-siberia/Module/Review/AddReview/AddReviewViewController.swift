import UIKit

class AddReviewViewController: ViewController<AddReviewView> {
    
    private let route: Route
    private let provider = AddReviewProvider()
    
    init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
        
        title = "Создать отзыв"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.sendButton.addTarget(self, action: #selector(sendReview), for: .touchUpInside)
        
        mainView.nameLabel.text = route.name
        mainView.textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendReview() {
        let text = mainView.textView.text ?? ""
        guard !text.isEmpty else { return }
        
        provider.sendReview(routeId: route.id, text: text) { [weak self] result in
            switch result {
            case .success:
                self?.dialog(title: "Ваш отзыв будет доступен другим пользователям после прохождения модерации",
                             onCancel: { [weak self] _ in
                    self?.close()
                })
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
}

// MARK: - UITextViewDelegate
extension AddReviewViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mainView.sendButton.isActive = !textView.text.isEmpty
    }
}
