import UIKit
import SnapKit

class ActiveButton: UIButton {
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = false
        view.startAnimating()
        view.isHidden = true
        view.color = .gray
        
        return view
    }()
    
    var isLoading = false {
        didSet {
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
    }
    
    var isActive: Bool = true {
        didSet {
            backgroundColor = isActive ? R.color.activeElements() : R.color.greyText()
            isUserInteractionEnabled = isActive
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = R.font.geometriaBold(size: 12.0)
        backgroundColor = R.color.activeElements()
        layer.cornerRadius = 5.0
        
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
    
}
