import UIKit
import SnapKit

class LoadingView: UIView {
    
    private let progressView: ProgressView = {
        let view = ProgressView()
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        addSubview(progressView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        progressView.isHidden = false
        alpha = 1
    }
    
    func stop() {
        progressView.isHidden = true
        alpha = 0
    }
    
    func setAnimationTintColor(_ color: UIColor) {
        progressView.tintColor = color
    }
    
    private func setupConstraints() {
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(12.0 * 3 + 4.0 * 3)
            make.height.equalTo(12.0)
        }
    }
    
}
