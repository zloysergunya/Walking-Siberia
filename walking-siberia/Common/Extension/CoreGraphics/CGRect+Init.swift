import UIKit
import CoreGraphics

extension CGRect {
    
    init(size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
    }

    init(side: CGFloat) {
        self.init(size: CGSize(width: side, height: side))
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }

    var y: CGFloat {
        get {
            return self.origin.y
        }
    }

    var x: CGFloat {
        get {
            return self.origin.x
        }
    }

    var maxY: CGFloat {
        get {
            return self.height + self.y
        }
    }

    var maxX: CGFloat {
        get {
            return self.width + self.x
        }
    }

    mutating func updateWithMaxWidth(_ maxWidth: CGFloat) {
        self.size.width = min(self.size.width, maxWidth)
    }

    func roundRect() -> CGRect {
        var newRect = CGRect()
        newRect.origin.x = round(self.origin.x)
        newRect.origin.y = round(self.origin.y)
        newRect.size.width = round(self.width)
        newRect.size.height = round(self.height)
        return newRect
    }

    func roundOrigin() -> CGRect {
        var newRect = self
        newRect.origin.x = round(self.origin.x)
        newRect.origin.y = round(self.origin.y)
        return newRect
    }

    func roundSize() -> CGRect {
        var newRect = self
        newRect.size.width = round(self.width)
        newRect.size.height = round(self.height)
        return newRect
    }

    func withX(_ x: CGFloat) -> CGRect {
        var rect = self
        rect.origin.x = x
        return rect
    }

    func withY(_ y: CGFloat) -> CGRect {
        var rect = self
        rect.origin.y = y
        return rect
    }

    func increaseXBy(_ xDiff: CGFloat) -> CGRect {
        return self.withX(self.origin.x + xDiff)
    }

    func increaseYBy(_ yDiff: CGFloat) -> CGRect {
        return self.withY(self.origin.y + yDiff)
    }

    func increaseWidthBy(_ wDiff: CGFloat) -> CGRect {
        return self.withWidth(self.width + wDiff)
    }

    func increaseHeightBy(_ hDiff: CGFloat) -> CGRect {
        return self.withHeight(self.height + hDiff)
    }

    func withWidth(_ width: CGFloat) -> CGRect {
        var rect = self
        rect.size.width = width
        return rect
    }

    func withHeight(_ height: CGFloat) -> CGRect {
        var rect = self
        rect.size.height = height
        return rect
    }

    func withOrigin(_ origin: CGPoint) -> CGRect {
        var rect = self
        rect.origin = origin
        return rect
    }

    func withSize(_ size: CGSize) -> CGRect {
        var rect = self
        rect.size = size
        return rect
    }

    func centeredHorizontallyInRect(_ rect: CGRect) -> CGRect {
        let width = self.width
        return self.withX((rect.width - width) / 2 + rect.origin.x)
    }

    func centeredVerticallyInRect(_ rect: CGRect) -> CGRect {
        let height = self.height
        return self.withY((rect.height - height) / 2 + rect.origin.y)
    }

    func centeredInRect(_ rect: CGRect)  -> CGRect {
        return self.centeredHorizontallyInRect(rect).centeredVerticallyInRect(rect)
    }

    mutating func centerInRect(_ rect: CGRect) {
        self = self.centeredInRect(rect)
    }

    mutating func centerHorizontallyInRect(_ rect: CGRect) {
        self = self.centeredHorizontallyInRect(rect)
    }

    mutating func centerVerticallyInRect(_ rect: CGRect) {
        self = self.centeredVerticallyInRect(rect)
    }

    func alignedBottomInRect(_ rect: CGRect, offset: CGFloat = 0) -> CGRect {
        let y = rect.height - self.height - offset + rect.origin.y
        return self.withY(y)
    }

    func alignedRightInRect(_ rect: CGRect, offset: CGFloat = 0) -> CGRect {
        let x = rect.width - self.width - offset  + rect.origin.x
        return self.withX(x)
    }

    func insetBy(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> CGRect {
        var rect = self
        rect.origin = CGPoint(x: left, y: top)
        rect.size.width = rect.width - left - right
        rect.size.height = rect.height - top - bottom
        return rect
    }

    func insetBy(insets: UIEdgeInsets) -> CGRect {
        return self.insetBy(left: insets.left, top: insets.top, right: insets.right, bottom: insets.bottom)
    }

    func insetBy(padding: CGFloat) -> CGRect {
        return self.insetBy(dx: padding, dy: padding)
    }
}
