import UIKit
import SnapKit
import MBCheckboxButton

class ManWithHIAView: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограниченные\nВозможности Здоровья"
        label.textColor = .black
        label.font = R.font.geometriaMedium(size: 14.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Человек, имеющий любую группу инвалидности."
        label.textColor = .init(hex: 0xAAABAD)
        label.font = R.font.geometriaRegular(size: 12.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    let checkBox = CheckboxButton()
        
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.mainContent()
        
        return view
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(checkBox)
        addSubview(separator)
        
        super.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        checkBox.checkBoxColor = CheckBoxColor(activeColor: R.color.activeElements() ?? .blue,
                                               inactiveColor: .white,
                                               inactiveBorderColor: R.color.activeElements() ?? .blue,
                                               checkMarkColor: .white)
        checkBox.checkboxLine = .init(checkBoxHeight: 27.0)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).offset(-16.0)
        }
        
        checkBox.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-8.0)
            make.size.equalTo(27.0)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
}
