import UIKit
import SnapKit

class ActiveButton: UIButton {
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = false
        view.startAnimating()
        view.isHidden = true
        view.color = .white
        
        return view
    }()
    
    var isLoading = false {
        didSet {
            updateLoadingState()
        }
    }
    
    var isActive: Bool = true {
        didSet {
            updateActiveState()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 38.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = R.font.geometriaBold(size: 12.0)
        backgroundColor = R.color.activeElements()
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        
        addSubview(loaderView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func updateLoadingState() {
        isUserInteractionEnabled = !isLoading
        if isLoading {
            imageView?.removeFromSuperview()
            titleLabel?.removeFromSuperview()
        } else {
            if let imageView = imageView {
                addSubview(imageView)
            }
            if let titleLabel = titleLabel {
                addSubview(titleLabel)
            }
        }
        
        isLoading ? loaderView.startAnimating() : loaderView.stopAnimating()
        loaderView.isHidden = !isLoading
    }
    
    private func updateActiveState() {
        backgroundColor = isActive ? R.color.activeElements() : R.color.greyText()
        isUserInteractionEnabled = isActive
    }
    
    private func updateSelectedState() {
        backgroundColor = isSelected ? .white : R.color.activeElements()
        loaderView.color = isSelected ? R.color.activeElements() : .white
        setTitleColor(isSelected ? R.color.activeElements() : .white, for: .normal)
        layer.borderColor = isSelected ? R.color.activeElements()?.cgColor : UIColor.clear.cgColor
    }
    
}
