import Swift_PageMenu

struct StyledPageMenuOptions: PageMenuOptions {
    var font: UIFont = R.font.geometriaMedium(size: 12) ?? .systemFont(ofSize: 12.0)
    var menuItemSize: PageMenuItemSize
    var menuItemMargin: CGFloat = 0.0
    var menuTitleColor: UIColor = .init(hex: 0x557998)
    var menuTitleSelectedColor: UIColor = R.color.activeElements() ?? .blue
    var menuCursor: PageMenuCursor = .underline(barColor: R.color.activeElements() ?? .blue, height: 1.0)
    var tabMenuBackgroundColor: UIColor = R.color.greyBackground() ?? .gray
    
    init(for count: Int) {
        menuItemSize = .fixed(width: UIScreen.main.bounds.width / CGFloat(count), height: 20.0)
    }
    
}
