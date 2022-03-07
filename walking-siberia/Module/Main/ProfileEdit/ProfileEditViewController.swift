import UIKit
import SnapKit
import MBRadioButton
import MessageUI

class ProfileEditViewController: ViewController<ProfileEditView> {
    
    private let provider = ProfileEditProvider()
    
    private var radioButtonContainer = RadioButtonContainer()
    private var selectedCategory: Int?
    private var isProfileEditing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        mainView.contentView.changePhotoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        mainView.contentView.personalInfoEditButton.addTarget(self, action: #selector(toggleProfileEditing), for: .touchUpInside)
        mainView.contentView.instructionActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInstruction)))
        mainView.contentView.aboutAppActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAboutApp)))
        mainView.contentView.writeToDevelopersActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contactDeveloper)))
        mainView.contentView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
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
        
        ImageLoader.setImage(url: user.profile.avatar, imgView: mainView.contentView.avatarImageView)
        
        mainView.contentView.nameTextField.text = user.profile.firstName
        mainView.contentView.surnameTextField.text = user.profile.lastName
        mainView.contentView.cityTextField.text = user.profile.city
        mainView.contentView.birthdayTextField.text = user.profile.birthDate
        mainView.contentView.heightTextField.text = "\(user.profile.height ?? 0)"
        mainView.contentView.weightTextField.text = "\(user.profile.weight ?? 0)"
        mainView.contentView.phoneTextField.text = user.phone
        mainView.contentView.emailTextField.text = user.email
        mainView.contentView.bioTextField.text = user.profile.aboutMe
        mainView.contentView.telegramField.text = user.profile.telegram
        mainView.contentView.instagramField.text = user.profile.instagram
        mainView.contentView.vkField.text = user.profile.vkontakte
        mainView.contentView.okField.text = user.profile.odnoklassniki
        
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
        
        let profileUpdate = ProfileUpdateRequest(lastName: mainView.contentView.surnameTextField.text,
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
                error.localizedDescription // todo
            }
        }
    }
    
    private func uploadUserPhoto(image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.5)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent("image.jpg")
        try? data?.write(to: filename)
        
        provider.uploadAvatar(photo: filename) { result in
            switch result {
            case .success:
                break
                
            case .failure(let error):
                if let error = error as? ModelError {
                    print(error.message())
                }
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
    
    @objc private func dateOfBirthDidChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        mainView.contentView.birthdayTextField.text = dateFormatter.string(from: mainView.contentView.datePicker.date)
    }
    
    @objc private func pickPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
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
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients(["info@iteo.pro"])
        let from = (UserSettings.user?.profile.firstName ?? "пользователя") + " " + (UserSettings.user?.profile.lastName ?? "")
        viewController.setSubject("Обращение от \(from)")
        
        let body = "\n\nbundleIdentifier: \(Constants.bundleIdentifier)\ndeviceModelName: \(Constants.deviceModelName)\nreleaseVersion: \(Constants.releaseVersion)\nbuildNumber: \(Constants.buildNumber)\nappVersion: \(Constants.appVersion)"
        viewController.setMessageBody(body, isHTML: false)
        present(viewController, animated: true)
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
