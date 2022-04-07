import UIKit
import Atributika
import MessageUI

class AboutAppViewController: ViewController<AboutAppView> {
    
    private let phone = "+71234567890"
    private let email = "ash_krsk@mail.ru"
    private let address = "Красноярск, ул. Ады Лебедевой, 64-37"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.contentView.descriptionLabel.text = "Приложение «Сибирь шагающая» создано Ассоциацией Скандинавской ходьбы Красноярского края при поддержке: Министерства образования Красноярского края, Красноярского регионального отделения партии «Единая Россия», ФГБУ \"Федеральный Центр сердечно-сосудистой хирургии\" г. Красноярск, краевой ДЮСШ, СШОР имени Б.Х. Сайтиева, КГБУ СО «Реабилитационный центр «Радуга», Фонда развития Богучанского района «За нами будущее», «Всероссийского общества инвалидов» (ВОИ) Богучанского района. Сопровождают проект волонтеры - студенческие отряды КСО.\n\nЦелью создания приложения является вовлечение детей, школьников, студентов, людей пожилого и пенсионного возраста, людей с ограниченными возможностями Красноярского края в осуществление физкультурно-оздоровительной деятельности, направленной на формирование навыков здорового образа жизни, укрепление физического и психологического здоровья, формирования привычки к активному образу жизни посредством вовлечения граждан в активную фоновую и скандинавскую ходьбу.\n\nЦель создания приложения достигается путем систематического проведения соревнований по ходьбе в командном и индивидуальном зачете, групповых тренировок под руководством сертифицированных инструкторов, самостоятельного изучения техники ходьбы с помощью видео-уроков.\n\nСтимулом к участию в соревнованиях является награждение победителей различными призами, также способствующими ведению ЗОЖ.  Также приложение предусматривает возможность изучить новые интересные маршруты для прогулок по г. Красноярску и познакомиться с участниками соревнований путем создания общих встреч через приложение.\n\nМы верим, что скандинавская ходьба – это путь к здоровью и долголетию, доступный каждому!"
        
        let a = Style("a").underlineStyle(NSUnderlineStyle.single).underlineColor(mainView.contentView.phoneLabel.textColor)
        
        mainView.contentView.phoneLabel.attributedText = "<a>\(phone.phonePattern(pattern: "+# ### ### ## ##", replacmentCharacter: "#"))</a>".style(tags: a).attributedString
        mainView.contentView.emailLabel.attributedText = "<a>\(email)</a>".style(tags: a).attributedString
        mainView.contentView.addressLabel.text = address
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.phoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(call)))
        mainView.contentView.emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendEmail)))
    }
    
    @objc private func call() {
        if let url = URL(string: "telprompt://\(phone)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            showError(text: "Прежде чем связаться с представителем, необходимо настроить почту в настройках телефона")
            return
        }
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients([email])
        present(viewController, animated: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate
extension AboutAppViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
