import UIKit

class SocialButton: UIButton {
    
    enum ButtonType {
        case telegram, instagram, vk, ok
    }
    
    var url: URL?
    
    private let type: ButtonType
    
    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
        
        switch type {
        case .telegram: setImage(R.image.telegram24(), for: .normal)
        case .instagram: setImage(R.image.instagram24(), for: .normal)
        case .vk: setImage(R.image.vk24(), for: .normal)
        case .ok: setImage(R.image.ok24(), for: .normal)
        }
        
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
