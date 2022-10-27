import UIKit

class AccountRegisterSecondaryViewController: ViewController<AccountRegisterSecondaryView> {
    
    private let provider = AccountRegisterSecondaryProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        mainView.addPhotoButton.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        mainView.continueButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        [mainView.bioField,
         mainView.telegramField,
         mainView.instagramField,
         mainView.vkField,
         mainView.okField,
         mainView.heightField,
         mainView.weightField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        }
    }
    
    private func updateContinueButtonTitle() {
        let isFilled = !(mainView.bioField.text?.isEmpty ?? true)
        || !(mainView.telegramField.text?.isEmpty ?? true)
        || !(mainView.instagramField.text?.isEmpty ?? true)
        || !(mainView.vkField.text?.isEmpty ?? true)
        || !(mainView.okField.text?.isEmpty ?? true)
        || !(mainView.heightField.text?.isEmpty ?? true)
        || !(mainView.weightField.text?.isEmpty ?? true)
        
        mainView.continueButton.setTitle(isFilled ? "Продолжить" : "Пропустить", for: .normal)
    }
    
    @objc private func textFieldDidChangeText() {
        updateContinueButtonTitle()
    }
    
    @objc private func pickPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true)
    }
    
    @objc private func nextStep() {
        let aboutMe = mainView.bioField.text
        let telegram = mainView.telegramField.text
        let instagram = mainView.instagramField.text
        let vkontakte = mainView.vkField.text
        let odnoklassniki = mainView.okField.text
        let height = Int(mainView.heightField.text ?? "")
        let weight = Int(mainView.weightField.text ?? "")
        
        let profileUpdate = ProfileUpdateRequest(phone: UserSettings.user?.phone,
                                                 lastName: UserSettings.user?.profile.lastName,
                                                 firstName: UserSettings.user?.profile.firstName,
                                                 city: UserSettings.user?.profile.city,
                                                 birthDay: UserSettings.user?.profile.birthDate,
                                                 email: UserSettings.user?.email,
                                                 isDisabled: UserSettings.user?.isDisabled,
                                                 aboutMe: aboutMe,
                                                 telegram: telegram,
                                                 instagram: instagram,
                                                 vkontakte: vkontakte,
                                                 odnoklassniki: odnoklassniki,
                                                 height: height,
                                                 weight: weight)
        
        mainView.continueButton.isLoading = true
        provider.profileUpdate(profileUpdate: profileUpdate) { [weak self] result in
            guard let self = self else {
                return
            }
            
            UserSettings.userReady = true
            self.mainView.continueButton.isLoading = false
            
            switch result {
            case .success(let response):
                UserSettings.user = response.data
                let uiService: UIService? = ServiceLocator.getService()
                uiService?.openModule()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func uploadUserPhoto(image: UIImage) {
        let data = image.fixedOrientation().compressTo(sizeInMb: 1)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = paths[0].appendingPathComponent("image.jpg")
        try? data?.write(to: filename)
        
        provider.uploadAvatar(photo: filename) { result in
            switch result {
            case .success:
                break
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension AccountRegisterSecondaryViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainView.addPhotoButton.setImage(image, for: .normal)
            uploadUserPhoto(image: image)
        }
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension AccountRegisterSecondaryViewController: UINavigationControllerDelegate {
    
}
