import UIKit
import SnapKit
import MBRadioButton
import MessageUI
import Firebase

class ProfileEditViewController: ViewController<ProfileEditView> {
    
    private let provider = ProfileEditProvider()
    
    private var radioButtonContainer = RadioButtonContainer()
    private var selectedCategory: Int?
    private var isProfileEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPickPhotoDialog)))
        mainView.contentView.changePhotoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPickPhotoDialog)))
        mainView.contentView.personalInfoEditButton.addTarget(self, action: #selector(toggleProfileEditing), for: .touchUpInside)
        mainView.contentView.instructionActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInstruction)))
        mainView.contentView.aboutAppActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAboutApp)))
        mainView.contentView.writeToDevelopersActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactDeveloper)))
        mainView.contentView.routesNotifyActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleRoutesNotifications)))
        mainView.contentView.competitionsNotifyActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCompetitionsNotifications)))
        mainView.contentView.infoNotifyActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleInfoNotifications)))
        mainView.contentView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        mainView.contentView.phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        mainView.contentView.datePicker.addTarget(self, action: #selector(dateOfBirthDidChange), for: .valueChanged)
        mainView.contentView.birthdayTextField.inputView = mainView.contentView.datePicker
        
        radioButtonContainer.delegate = self
        radioButtonContainer.addButtons([mainView.contentView.schoolchildRadioButton,
                                         mainView.contentView.studentRadioButton,
                                         mainView.contentView.adultRadioButton,
                                         mainView.contentView.pensionerRadioButton,
                                         mainView.contentView.manWithHIARadioButton])
        
        configure()
    }
    
    private func configure() {
        guard let user = UserSettings.user else {
            return
        }
        
        if let url = user.profile.avatar {
            ImageLoader.setImage(url: url, imgView: mainView.contentView.avatarImageView)
        } else {
            let side = 120.0
            let fullName = "\(user.profile.firstName) \(user.profile.lastName)"
            let textAttributes: [NSAttributedString.Key: Any] = [.font: R.font.geometriaMedium(size: 42.0)!, .foregroundColor: UIColor.white]
            mainView.contentView.avatarImageView.image = UIImage.createWithBgColorFromText(text: fullName.getInitials(),
                                                                                           color: .clear,
                                                                                           circular: true,
                                                                                           textAttributes: textAttributes,
                                                                                           side: side)
            let gradientLayer = GradientHelper.shared.layer(userId: user.userId)
            gradientLayer?.frame = CGRect(side: side)
            mainView.contentView.gradientLayer = gradientLayer
            mainView.contentView.layoutIfNeeded()
        }
        
        mainView.contentView.nameTextField.text = user.profile.firstName
        mainView.contentView.surnameTextField.text = user.profile.lastName
        mainView.contentView.cityTextField.text = user.profile.city
        mainView.contentView.birthdayTextField.text = user.profile.birthDate
        mainView.contentView.heightTextField.text = "\(user.profile.height ?? 0)"
        mainView.contentView.weightTextField.text = "\(user.profile.weight ?? 0)"
        mainView.contentView.phoneTextField.text = user.phone?.phonePattern(pattern: "+# (###) ### ## ##", replacmentCharacter: "#")
        mainView.contentView.emailTextField.text = user.email
        mainView.contentView.bioTextField.text = user.profile.aboutMe
        mainView.contentView.telegramField.text = user.profile.telegram
        mainView.contentView.instagramField.text = user.profile.instagram
        mainView.contentView.vkField.text = user.profile.vkontakte
        mainView.contentView.okField.text = user.profile.odnoklassniki
        
        mainView.contentView.routesNotifyActionView.switcherView.isOn = user.profile.isNoticeRoute
        mainView.contentView.competitionsNotifyActionView.switcherView.isOn = user.profile.isNoticeCompetition
        mainView.contentView.infoNotifyActionView.switcherView.isOn = user.profile.isNoticeInfo
        
        switch user.type {
        case 0:
            mainView.contentView.categoryTextField.text = "Админ"
            
        case 5:
            mainView.contentView.categoryTextField.text = "Пользователь"
            
        case 10:
            mainView.contentView.categoryTextField.text = "Дети"
            radioButtonContainer.selectedButton = radioButtonContainer.allButtons[0]
            
        case 20:
            mainView.contentView.categoryTextField.text = "Молодежь"
            radioButtonContainer.selectedButton = radioButtonContainer.allButtons[1]
            
        case 30:
            mainView.contentView.categoryTextField.text = "Взрослые"
            radioButtonContainer.selectedButton = radioButtonContainer.allButtons[2]
            
        case 40:
            mainView.contentView.categoryTextField.text = "Старшее поколение"
            radioButtonContainer.selectedButton = radioButtonContainer.allButtons[3]
            
        case 50:
            mainView.contentView.categoryTextField.text = "Человек с ОВЗ"
            radioButtonContainer.selectedButton = radioButtonContainer.allButtons[4]
            
        default:
            mainView.contentView.categoryTextField.text = "Другое"
        }
    }
    
    private func save() {
        guard let type = selectedCategory else {
            return
        }
        
        guard let phone = mainView.contentView.phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty else {
            Animations.shake(view: mainView.contentView.phoneTextField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        let formattedPhone = String(phone.phonePattern(pattern: "+###########", replacmentCharacter: "#"))
        let profileUpdate = ProfileUpdateRequest(phone: formattedPhone,
                                                 lastName: mainView.contentView.surnameTextField.text,
                                                 firstName: mainView.contentView.nameTextField.text,
                                                 city: mainView.contentView.cityTextField.text,
                                                 birthDay: mainView.contentView.birthdayTextField.text,
                                                 email: mainView.contentView.emailTextField.text,
                                                 type: type * 10,
                                                 aboutMe: mainView.contentView.bioTextField.text,
                                                 telegram: mainView.contentView.telegramField.text,
                                                 instagram: mainView.contentView.instagramField.text,
                                                 vkontakte: mainView.contentView.vkField.text,
                                                 odnoklassniki: mainView.contentView.okField.text,
                                                 height: Int(mainView.contentView.heightTextField.text ?? ""),
                                                 weight: Int(mainView.contentView.weightTextField.text ?? ""))
        
        provider.profileUpdate(profileUpdate: profileUpdate) { [weak self] result in
            switch result {
            case .success(let response):
                UserSettings.user = response.data
                self?.configure()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
                self?.toggleProfileEditing()
            }
        }
    }
    
    private func uploadUserPhoto(image: UIImage) {
        let data = image.compressTo(sizeInMb: 1)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent("image.jpg")
        try? data?.write(to: filename)
        
        provider.uploadAvatar(photo: filename) { [weak self] result in
            switch result {
            case .success: break
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func toggleProfileEditing() {
        if isProfileEditing {
            save()
        }
        
        isProfileEditing.toggle()
        
        if isProfileEditing {
            mainView.contentView.personalInfoEditButton.setImage(nil, for: .normal)
            mainView.contentView.personalInfoEditButton.setTitle("Готово", for: .normal)
        } else {
            mainView.contentView.personalInfoEditButton.setImage(R.image.editFill24(), for: .normal)
            mainView.contentView.personalInfoEditButton.setTitle(nil, for: .normal)
        }
        
        [mainView.contentView.nameTextField, mainView.contentView.surnameTextField, mainView.contentView.cityTextField,
         mainView.contentView.birthdayTextField, mainView.contentView.categoryTextField, mainView.contentView.heightTextField,
         mainView.contentView.weightTextField, mainView.contentView.phoneTextField, mainView.contentView.emailTextField,
         mainView.contentView.bioTextField, mainView.contentView.telegramField, mainView.contentView.instagramField,
         mainView.contentView.vkField, mainView.contentView.okField].forEach {
            $0.isUserInteractionEnabled = isProfileEditing
        }
        
        mainView.contentView.categoryTextField.isHidden = isProfileEditing
        mainView.contentView.radioButtonsStackView.isHidden = !isProfileEditing
        mainView.contentView.layoutIfNeeded()
        mainView.contentView.radioButtonsStackView.arrangedSubviews.map({ $0 as? RadioButton }).forEach({
            $0?.radioCircle = RadioButtonCircleStyle(outerCircle: 16.0, innerCircle: 8.0, outerCircleBorder: 1.0, contentPadding: 4.0)
            $0?.radioButtonColor = RadioButtonColor(active: R.color.activeElements() ?? .blue, inactive: R.color.activeElements() ?? .blue)
        })
    }
    
    private func deleteAvatar() {
        provider.deleteAvatar() { [weak self] result in
            switch result {
            case .success:
                UserSettings.user?.profile.avatar = nil
                self?.configure()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func toggleNotice(notice: NotificationTopic) {
        provider.toggleNotice(type: notice.rawValue) { [weak self] result in
            switch result {
            case .success:
                switch notice {
                case .route: UserSettings.user?.profile.isNoticeRoute.toggle()
                case .info: UserSettings.user?.profile.isNoticeInfo.toggle()
                case .competition: UserSettings.user?.profile.isNoticeCompetition.toggle()
                }
                
                Utils.impact()
                self?.configure()
                
            case .failure(let error):
                self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func dateOfBirthDidChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        mainView.contentView.birthdayTextField.text = dateFormatter.string(from: mainView.contentView.datePicker.date)
    }
    
    @objc private func openPickPhotoDialog() {
        let alert = UIAlertController(title: "Выберите действие", message: "", preferredStyle: .actionSheet)
        let pickPhotoAction = UIAlertAction(title: "Выбрать фото", style: .default) { [weak self] _ in
            self?.pickPhoto(sourceType: .photoLibrary)
        }
        let makePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            self?.pickPhoto(sourceType: .camera)
        }
        let deleteAvatarAction = UIAlertAction(title: "Удалить фото", style: .default) { [weak self] _ in
            self?.deleteAvatar()
        }
        
        alert.addAction(pickPhotoAction)
        alert.addAction(makePhotoAction)
        alert.addAction(deleteAvatarAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func pickPhoto(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true)
    }
    
    @objc private func openInstruction() {
        navigationController?.pushViewController(InstructionViewController(), animated: true)
    }
    
    @objc private func openAboutApp() {
        navigationController?.pushViewController(AboutAppViewController(), animated: true)
    }
    
    @objc private func contactDeveloper() {
        guard MFMailComposeViewController.canSendMail() else {
            showError(text: "Прежде чем написать разработчикам, настройте почту в настройках телефона")
            return
        }
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients(["info@iteo.pro"])
        let from = (UserSettings.user?.profile.firstName ?? "пользователя") + " " + (UserSettings.user?.profile.lastName ?? "")
        viewController.setSubject("Обращение от \(from)")
        
        let body = "\n\nbundleIdentifier: \(Constants.bundleIdentifier)\ndeviceModelName: \(Constants.deviceModelName)\nreleaseVersion: \(Constants.releaseVersion)\nbuildNumber: \(Constants.buildNumber)\nappVersion: \(Constants.appVersion)"
        viewController.setMessageBody(body, isHTML: false)
        present(viewController, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.phonePattern(pattern: "+# (###) ### ## ##", replacmentCharacter: "#")
    }
    
    @objc private func toggleRoutesNotifications() {
        NotificationsAccessService.unsubscribe(fromTopic: .route)
        toggleNotice(notice: .route)
    }
    
    @objc private func toggleCompetitionsNotifications() {
        NotificationsAccessService.unsubscribe(fromTopic: .competition)
        toggleNotice(notice: .competition)
    }
    
    @objc private func toggleInfoNotifications() {
        NotificationsAccessService.unsubscribe(fromTopic: .info)
        toggleNotice(notice: .info)
    }
    
    @objc private func logout() {
        let authService: AuthService? = ServiceLocator.getService()
        authService?.deauthorize()
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - RadioButtonDelegate
extension ProfileEditViewController: RadioButtonDelegate {
    
    func radioButtonDidSelect(_ button: RadioButton) {
        selectedCategory = mainView.contentView.radioButtonsStackView.arrangedSubviews
            .map({ $0 as? RadioButton })
            .firstIndex(where: { $0?.title(for: .normal) == button.title(for: .normal) })
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {}
    
}

// MARK: - ConstraintKeyboardObserver
extension ProfileEditViewController: ConstraintKeyboardObserver {
    var keyboardConstraint: Constraint { mainView.scrollViewBottomConstraint }
}


// MARK: - UIImagePickerControllerDelegate
extension ProfileEditViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainView.contentView.avatarImageView.image = image
            uploadUserPhoto(image: image)
        }
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileEditViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension ProfileEditViewController: UINavigationControllerDelegate {
    
}
