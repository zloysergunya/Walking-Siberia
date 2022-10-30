import UIKit
import SnapKit

enum ProfileEditCellIconType {
    case arrow, switcher
}

class ProfileEditCellView: UIView {
    
    private let iconType: ProfileEditCellIconType
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.mainContent()
        label.font = R.font.geometriaMedium(size: 14.0)
        
        return label
    }()
    
    private let arrowImageView = UIImageView(image: R.image.chevronRight24())
    
    let switcherView: UISwitch = {
        let view = UISwitch()
        view.onTintColor = R.color.activeElements()
        view.tintColor = R.color.grey()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x082238)
        
        return view
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 36.0)
    }
    
    init(title: String, iconType: ProfileEditCellIconType) {
        self.iconType = iconType
        super.init(frame: .zero)
        
        isUserInteractionEnabled = true
        
        titleLabel.text = title
        arrowImageView.isHidden = iconType != .arrow
        switcherView.isHidden = iconType != .switcher
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(switcherView)
        addSubview(separator)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.0)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
        switcherView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.0)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
}
