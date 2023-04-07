import UIKit
import SwiftyMenu

protocol DropDownViewDelegate: AnyObject {
    func dropDownView(_ dropDownView: DropDownView, didSelect item: SwiftyMenuDisplayable, at index: Int)
}

class DropDownView: RootView {
    
    weak var delegate: DropDownViewDelegate?
    var items: [SwiftyMenuDisplayable] = [] {
        didSet {
            menuView.items = items
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            menuView.selectedIndex = selectedIndex
        }
    }
    
    private let menuView = SwiftyMenu()
    private let menuAttributes: SwiftyMenuAttributes = {
        var attributes = SwiftyMenuAttributes()
        // Custom Behavior
        attributes.multiSelect = .disabled
        attributes.hideOptionsWhenSelect = .enabled
        
        // Custom UI
        attributes.roundCorners = .all(radius: 5)
        attributes.rowStyle = .value(height: 38, backgroundColor: .white, selectedColor: R.color.greyLight()!)
        attributes.headerStyle = .value(backgroundColor: .white, height: 38)
        attributes.placeHolderStyle = .value(text: "Please Select Size", textColor: .lightGray)
        attributes.textStyle = .value(color: R.color.mainContent()!, separator: "", font: R.font.geometriaMedium(size: 12.0))
        attributes.separatorStyle = .value(color: .clear, isBlured: false, style: .none)
        attributes.accessory = .disabled
        
        // Custom Animations
        attributes.expandingAnimation = .linear
        attributes.expandingTiming = .value(duration: 0.5, delay: 0)
        attributes.collapsingAnimation = .linear
        attributes.collapsingTiming = .value(duration: 0.5, delay: 0)
        
        return attributes
    }()
    
    override func setup() {
        addSubview(menuView)
        
        menuView.delegate = self
        menuView.configure(with: menuAttributes)
        
        addShadow()
        
        super.setup()
    }
    
    override func setupConstraints() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        menuView.heightConstraint = menuView.heightAnchor.constraint(equalToConstant: 38.0)
        
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: self.topAnchor),
            menuView.leftAnchor.constraint(equalTo: self.leftAnchor),
            menuView.rightAnchor.constraint(equalTo: self.rightAnchor),
            menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menuView.heightConstraint
        ])
    }
    
}

// MARK: - SwiftyMenuDelegate
extension DropDownView: SwiftyMenuDelegate {
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        delegate?.dropDownView(self, didSelect: item, at: index)
    }
}
