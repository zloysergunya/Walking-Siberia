import UIKit

class AddButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            UIView.transition(with: self, duration: 0.2, options: .curveEaseInOut) { [weak self] in
                self?.updateState()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = R.font.geometriaBold(size: 12.0)
        setTitleColor(.white, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
        layer.cornerRadius = 5.0
        
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateState() {
        if isSelected {
            setTitle(nil, for: .normal)
            setImage(R.image.close20(), for: .selected)
            backgroundColor = .clear
        } else {
            setTitle("Добавить", for: .normal)
            setImage(nil, for: .selected)
            backgroundColor = R.color.activeElements()
        }
    }
    
}
