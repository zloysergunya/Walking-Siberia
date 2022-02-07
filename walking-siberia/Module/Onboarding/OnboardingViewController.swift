import UIKit
import Atributika
import SafariServices

class OnboardingViewController: ViewController<OnboardingView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.signInButton.addTarget(self, action: #selector(openPhoneAuth), for: .touchUpInside)

        configure()
    }
    
    private func configure() {
        
        let a = Style("a")
            .underlineStyle(NSUnderlineStyle.single).underlineColor(mainView.policyLabel.textColor)
            .foregroundColor(mainView.policyLabel.textColor.withAlphaComponent(0.5), .highlighted)
        
        let policyText = "Создавая аккаунт, вы принимаете\n<a href='https://google.com'>условия использования</a>"
        mainView.policyLabel.attributedText = policyText.style(tags: a)
        mainView.policyLabel.onClick = { [weak self] label, detection in
            self?.handleOnClick(label: label, detection: detection)
        }
    }
    
    private func handleOnClick(label: AttributedLabel, detection: Detection) {
        switch detection.type {
        case .tag(let tag):
            if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                openSafari(url: url)
            }
            
        default: break
        }
    }
    
    private func openSafari(url: URL) {
        present(SFSafariViewController(url: url), animated: true)
    }
    
    @objc private func openPhoneAuth() {
        navigationController?.pushViewController(PhoneAuthViewController(), animated: true)
    }

}
