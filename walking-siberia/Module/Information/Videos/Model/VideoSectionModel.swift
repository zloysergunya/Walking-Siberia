import IGListDiffKit

class VideoSectionModel {
    
    let video: Video
    
    init(video: Video) {
        self.video = video
    }
    
}

// MARK: - ListDiffable
extension VideoSectionModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return String(video.id) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else {
            return false
        }
        
        return object.video == video
    }
    
}
