import UIKit

class ChipsButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            updateState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .selected)
        setTitleColor(R.color.activeElements(), for: .normal)
        titleLabel?.font = R.font.geometriaMedium(size: 12.0)
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
        layer.borderWidth = 1.0
        layer.cornerRadius = 15.0
        
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateState() {
        UIView.transition(with: self, duration: 0.3, options: .curveEaseInOut) {
            if self.isSelected {
                self.backgroundColor = R.color.activeElements()
                self.layer.borderColor = UIColor.clear.cgColor
            } else {
                self.backgroundColor = .white
                self.layer.borderColor =  R.color.activeElements()?.cgColor
            }
        }
    }
    
}
