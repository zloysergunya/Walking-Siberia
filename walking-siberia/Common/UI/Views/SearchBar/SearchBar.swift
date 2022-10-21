import UIKit

class SearchBar: UISearchBar {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 32.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchTextField.font = R.font.geometriaMedium(size: 14.0)
        searchTextField.placeholder = "Поиск"
        searchBarStyle = .minimal
        searchTextField.textColor = .black
        tintColor = .black
        barTintColor = R.color.greyLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
