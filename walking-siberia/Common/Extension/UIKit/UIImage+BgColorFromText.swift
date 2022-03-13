import UIKit

extension UIImage {
    
    static func createWithBgColorFromText(text: String,
                                          color: UIColor,
                                          circular: Bool,
                                          textAttributes: [NSAttributedString.Key: Any]? = nil,
                                          side: CGFloat) -> UIImage? {
        
        return imageSnapshot(text: text,
                             color: color,
                             circular: circular,
                             textAttributes: textAttributes,
                             bounds: CGRect(origin: .zero, size: CGSize(width: side, height: side)))
    }
    
    private static func imageSnapshot(text: String?,
                                      color: UIColor = .blue,
                                      circular: Bool,
                                      textAttributes: [NSAttributedString.Key: Any]?,
                                      bounds: CGRect) -> UIImage? {
        let scale = UIScreen.main.scale
        let size = bounds.size

        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPath(ellipseIn: bounds, transform: nil)
            context?.addPath(path)
            context?.clip()
        }
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if let text = text {
            let attributes = textAttributes ?? [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                NSAttributedString.Key.font: R.font.geometriaBold(size: 16.0) ?? .systemFont(ofSize: 16.0)]
            
            let textSize = text.size(withAttributes: attributes)
            let bounds = bounds
            let rect = CGRect(x: bounds.size.width / 2 - textSize.width / 2, y: bounds.size.height / 2 - textSize.height / 2, width: textSize.width, height: textSize.height)
            
            text.draw(in: rect, withAttributes: attributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
