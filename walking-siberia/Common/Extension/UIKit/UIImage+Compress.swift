import UIKit

extension UIImage {
    
    func compressTo(sizeInMb: Int) -> Data? {
        let sizeInBytes = sizeInMb * 1024 * 1024
        var needCompress = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        
        while needCompress && compressingValue > 0.0 {
            if let data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData, data.count < sizeInBytes {
            return data
        }
        
        return nil
    }
    
}
