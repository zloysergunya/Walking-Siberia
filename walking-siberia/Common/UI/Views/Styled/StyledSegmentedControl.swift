import UIKit

class StyledSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = R.color.activeElements()?.cgColor
        layer.borderWidth = 1.0
        
        let selectedColor = R.color.activeElements() ?? .blue
        let font = R.font.geometriaMedium(size: 14.0) ?? .systemFont(ofSize: 15, weight: .medium)
        setTitleTextAttributes([.foregroundColor: selectedColor, .font: font], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white, .font: font], for: .selected)
        
        setBackgroundImage(UIImage(color: .white), for: .normal, barMetrics: .default)
        setBackgroundImage(UIImage(color: selectedColor), for: .selected, barMetrics: .default)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 16.0
    }
    
}
