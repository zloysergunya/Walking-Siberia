import UIKit
import Atributika
import SafariServices

class ArticleViewController: ViewController<ArticleView> {
    
    private let article: Article
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navBar.leftButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configure() {
        ImageLoader.setImage(url: article.image, imgView: mainView.contentView.imageView)
        
        mainView.contentView.nameLabel.text = article.title
        mainView.contentView.textLabel.text = article.content
        
        if let source = article.link, !source.isEmpty {
            let mediumFont = Style("medium").font(R.font.geometriaMedium(size: 14.0) ?? .systemFont(ofSize: 14.0, weight: .medium))
            let a = Style("a")
                .underlineStyle(NSUnderlineStyle.single).underlineColor(mainView.contentView.sourceLabel.textColor)
                .foregroundColor(mainView.contentView.sourceLabel.textColor.withAlphaComponent(0.5), .highlighted)
            let text = "<medium>Источник</medium>: <a href='\(source)'>\(source)</a>"
            mainView.contentView.sourceLabel.attributedText = text.style(tags: mediumFont, a)
            
            mainView.contentView.sourceLabel.onClick = { [weak self] (_, detection) in
                switch detection.type {
                case .tag(let tag):
                    if tag.name == "a", let href = tag.attributes["href"], let url = URL(string: href) {
                        self?.openSafari(url: url)
                    }
                    
                default: break
                }
            }
        }
    }
    
    private func openSafari(url: URL) {
        present(SFSafariViewController(url: url), animated: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}
