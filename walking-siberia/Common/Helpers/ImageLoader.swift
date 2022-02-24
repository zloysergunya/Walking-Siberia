import Kingfisher

class ImageLoader {
    
    @discardableResult
    static func setImage(url: String?, imgView: UIImageView, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else {
            return nil
        }
        
        let options: KingfisherOptionsInfo = [
            .loadDiskFileSynchronously,
            .transition(.fade(0.2)),
        ]

        return imgView.kf.setImage(with: URL(string: url), options: options, completionHandler: completionHandler)
    }
    
}
