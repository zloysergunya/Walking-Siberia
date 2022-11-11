import Foundation

enum LoadingState: Equatable {
    case none
    case loading
    case loaded
    case failed(error: Error)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
           
        case (.loading, .loading):
            return true
            
        case (.loaded, .loaded):
            return true
            
        default: return false
        }
    }
}
