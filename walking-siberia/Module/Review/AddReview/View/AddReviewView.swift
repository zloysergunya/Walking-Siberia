import UIKit
import SnapKit
import RSKPlaceholderTextView

class AddReviewView: RootView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaBold(size: 20.0)
        label.textColor = R.color.mainContent()
        label.numberOfLines = 2
        
        return label
    }()
    
    private let textViewShadowView: UIView = {
        let view = UIView()
        view.addShadow()
        
        return view
    }()
    
    let textView: RSKPlaceholderTextView = {
        let textView = RSKPlaceholderTextView()
        textView.font = R.font.geometriaRegular(size: 14.0)
        textView.textColor = R.color.mainContent()
        textView.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        textView.layer.cornerRadius = 12.0
        textView.placeholder = "Поделитесь впечатлениями!"
        
        return textView
    }()
    
    let sendButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Отправить", for: .normal)
        button.isActive = false
        
        return button
    }()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(nameLabel)
        addSubview(textViewShadowView)
        addSubview(sendButton)
        
        textViewShadowView.addSubview(textView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        textViewShadowView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(210.0)
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
    }
    
}
