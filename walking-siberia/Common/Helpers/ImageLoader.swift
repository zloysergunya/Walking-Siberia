import Kingfisher
import UIKit

class ImageLoader {
    
    @discardableResult
    static func setImage(url: String?,
                         imgView: UIImageView,
                         placeholder: UIImage? = nil,
                         completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else { return nil }
        
        let options: KingfisherOptionsInfo = [
            .loadDiskFileSynchronously,
            .transition(.fade(0.2)),
        ]

        return imgView.kf.setImage(with: URL(string: url), placeholder: placeholder, options: options, completionHandler: completionHandler)
    }
    
}
