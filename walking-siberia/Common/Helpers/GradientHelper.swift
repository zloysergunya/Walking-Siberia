import UIKit

struct Gradient {
    let id: Int
    let colors: [UIColor]
}

enum GradientColor: Int {
    case linearBlueLight
    case linearBlue
    case linearRed
}

class GradientHelper {
    
    static let shared = GradientHelper()
    
    let list: [Gradient] = [
        Gradient(id: 0, colors: [.init(hex: 0x2DA6DE), .init(hex: 0x69CEF5)]),
        Gradient(id: 1, colors: [.init(hex: 0x1B619F), .init(hex: 0x27A3DB)]),
        Gradient(id: 2, colors: [.init(hex: 0xE5352C), .init(hex: 0xF58148)]),
    ]
    
    func layer(userId: Int) -> CAGradientLayer? {
        if let gradientColor = GradientColor(rawValue: userId % list.count) {
            return layer(color: gradientColor)
        }
        
        return nil
    }

    func layer(color: GradientColor) -> CAGradientLayer? {
        let gradient = list[color.rawValue]
        let layer = CAGradientLayer()
        layer.colors = [gradient.colors[0].cgColor, gradient.colors[1].cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        
        return layer
    }
    
}
