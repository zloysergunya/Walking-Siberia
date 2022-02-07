import UIKit

protocol OTPTextFieldDelegate: AnyObject {
    func didUserFinishEnter(the code: String)
}

class OTPTextField: UITextField {

    var otpDefaultCharacter = ""
    var otpBackgroundColor: UIColor = .gray
    var otpFilledBackgroundColor: UIColor = .darkGray
    var otpCornerRaduis: CGFloat = 8.0
    var otpDefaultBorderColor: UIColor = .clear
    var otpFilledBorderColor: UIColor = .darkGray
    var otpDefaultBorderWidth: CGFloat = 0.0
    var otpFilledBorderWidth: CGFloat = 1.0
    var otpTextColor: UIColor = .black
    var otpFontSize: CGFloat = 14.0
    var otpFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    weak var otpDelegate: OTPTextFieldDelegate?
    
    private var implementation = OTPTextFieldImplementation()
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        
        return recognizer
    }()
    
    func configure(with slotCount: Int = 6) {
        guard !isConfigured else {
            return
        }
        
        isConfigured.toggle()
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        borderStyle = .none
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = implementation
        implementation.implementationDelegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        for i in 0..<count {
            let label = createLabel(isFirst: i == 0)
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    private func createLabel(isFirst: Bool) -> UILabel {
        let label = UILabel()
        label.backgroundColor = otpBackgroundColor
        label.layer.cornerRadius = otpCornerRaduis
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = otpTextColor
        label.font = label.font.withSize(otpFontSize)
        label.font = otpFont
        label.isUserInteractionEnabled = true
        label.layer.masksToBounds = true
        label.text = otpDefaultCharacter
        label.layer.borderWidth = otpDefaultBorderWidth
        label.layer.borderColor = isFirst ? otpFilledBorderColor.cgColor : otpDefaultBorderColor.cgColor
        
        return label
    }
    
    @objc private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        for labelIndex in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[labelIndex]
            if labelIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: labelIndex)
                currentLabel.text = String(text[index])
                currentLabel.layer.borderWidth = otpFilledBorderWidth
                currentLabel.layer.borderColor = otpFilledBorderColor.cgColor
                currentLabel.backgroundColor = otpFilledBackgroundColor
            } else {
                currentLabel.text = otpDefaultCharacter
                currentLabel.layer.borderWidth = otpDefaultBorderWidth
                currentLabel.layer.borderColor = otpDefaultBorderColor.cgColor
                currentLabel.backgroundColor = otpBackgroundColor
            }
        }
        if text.count == digitLabels.count {
            otpDelegate?.didUserFinishEnter(the: text)
        }
    }
}

// MARK: - OTPTextFieldImplementationProtocol
extension OTPTextField: OTPTextFieldImplementationProtocol {
    
    func digitalLabelsCount() -> Int {
        digitLabels.count
    }
    
}
