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
    
    let loadingView = LoadingView()
    
    convenience init(loadingState: LoadingState) {
        self.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(loadingView)
        
        switch loadingState {
        case .none:
            break
            
        case .loading:
            loadingView.play()
            titleLabel.isHidden = true
            
        case .loaded:
            loadingView.stop()
            titleLabel.isHidden = false
            
        case .failed(let error):
            if let error = error as? ModelError {
                titleLabel.text = error.localizedDescription
            } else {
                titleLabel.text = error.localizedDescription
            }
            
            loadingView.stop()
            titleLabel.isHidden = false
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
