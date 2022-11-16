import UIKit

class AccountRegisterPrimaryViewController: ViewController<AccountRegisterPrimaryView> {
    
    private let provider = AccountRegisterPrimaryProvider()    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        [mainView.nameField,
         mainView.surnameField,
         mainView.cityField,
         mainView.phoneField,
         mainView.dateOfBirthField,
         mainView.emailField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        }
        
        mainView.nameField.text = UserSettings.user?.profile.firstName
        mainView.nameField.isUserInteractionEnabled = mainView.nameField.text?.isEmpty == true
        
        mainView.surnameField.text = UserSettings.user?.profile.lastName
        mainView.surnameField.isUserInteractionEnabled = mainView.surnameField.text?.isEmpty == true
        
        mainView.emailField.text = UserSettings.user?.email
        mainView.emailField.isUserInteractionEnabled = mainView.emailField.text?.isEmpty == true
        if let authType = UserSettings.authType, authType != .phone {
            mainView.emailField.placeholder = "E-mail, привязанный к учётной записи \(authType.description)"
        }
        
        mainView.phoneField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        mainView.phoneField.isHidden = UserSettings.authType == .phone
        
        mainView.datePicker.addTarget(self, action: #selector(dateOfBirthDidChange), for: .valueChanged)
        mainView.dateOfBirthField.inputView = mainView.datePicker
                
        mainView.continueButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    }
    
    private func updateContinueButtonState() {
        let isActive = !(mainView.nameField.text?.isEmpty ?? true)
        && !(mainView.surnameField.text?.isEmpty ?? true)
        && !(mainView.cityField.text?.isEmpty ?? true)
        && !(mainView.dateOfBirthField.text?.isEmpty ?? true)
        && !(mainView.emailField.text?.isEmpty ?? true)

        mainView.continueButton.isActive = isActive
    }
    
    @objc private func textFieldDidChangeText() {
        updateContinueButtonState()
    }
    
    @objc private func dateOfBirthDidChange() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        mainView.dateOfBirthField.text = dateFormatter.string(from: mainView.datePicker.date)
        updateContinueButtonState()
    }
    
    @objc private func nextStep() {
        guard let name = mainView.nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            Animations.shake(view: mainView.nameField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        guard let surname = mainView.surnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !surname.isEmpty else {
            Animations.shake(view: mainView.surnameField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        guard let city = mainView.cityField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            Animations.shake(view: mainView.cityField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        guard let phone = mainView.phoneField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty else {
            Animations.shake(view: mainView.phoneField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        guard let dateOfBirth = mainView.dateOfBirthField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dateOfBirth.isEmpty else {
            Animations.shake(view: mainView.dateOfBirthField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        guard let email = mainView.emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty, isValidEmail(email) else {
            Animations.shake(view: mainView.emailField)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            return
        }
        
        let formattedPhone = String(phone.phonePattern(pattern: "+###########", replacmentCharacter: "#"))
        let isDisabled = mainView.manWithHIAView.checkBox.isSelected
        let profileUpdate = ProfileUpdateRequest(phone: UserSettings.authType != .phone ? formattedPhone : UserSettings.user?.phone,
                                                 lastName: surname,
                                                 firstName: name,
                                                 city: city,
                                                 birthDay: dateOfBirth,
                                                 email: email,
                                                 isDisabled: isDisabled)
        
        mainView.continueButton.isLoading = true
        provider.profileUpdate(profileUpdate: profileUpdate) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.continueButton.isLoading = false
            
            switch result {
            case .success(let response):
                UserSettings.user = response.data
                UserSettings.userReady = true
                self.navigationController?.pushViewController(AccountRegisterSecondaryViewController(), animated: true)
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegularExpression = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$"
        
        return NSPredicate(format:"SELF MATCHES %@", emailRegularExpression).evaluate(with: email)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.phonePattern(pattern: "+# (###) ### ## ##", replacmentCharacter: "#")
    }
    
}
