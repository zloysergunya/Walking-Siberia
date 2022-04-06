import UIKit

class BadgeButton: UIButton {

    private let badgeLabel = UILabel()

    var badge: String? {
        didSet {
            addBadgeToButton(badge: badge)
        }
    }

    var badgeBackgroundColor: UIColor? = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }

    var badgeTextColor: UIColor? = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    var badgeFont: UIFont? = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButton(badge: badge)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addBadgeToButton(badge: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addBadgeToButton(badge: nil)
    }

    func addBadgeToButton(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        
        let badgeSize = badgeLabel.frame.size
        let inset: CGFloat = 2.0
        let height: CGFloat = max(18.0, Double(badgeSize.height) + inset)
        let width: CGFloat = max(height, Double(badgeSize.width) + inset)

        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)

            let x: CGFloat = bounds.size.width - 10.0 + horizontal!
            let y: CGFloat = -(badgeSize.height / 2) - 10.0 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x: CGFloat = 0.0
            let y: CGFloat = height / 2
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        }

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height / 2
        badgeLabel.layer.masksToBounds = true
        badgeLabel.isHidden = badge != nil ? false : true
        
        addSubview(badgeLabel)
    }
    
}
