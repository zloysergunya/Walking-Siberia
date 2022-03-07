import UIKit
import SnapKit

class EmptyView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока здесь ничего нет"
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.greyText()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
        }
        
    }

}
