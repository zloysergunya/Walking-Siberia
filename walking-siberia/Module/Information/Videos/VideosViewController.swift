import UIKit
import IGListKit
import AVFoundation
import AVKit

class VideosViewController: ViewController<VideosView> {
    
    private let provider = VideosProvider()
    
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private var objects: [VideoSectionModel] = []
    private var loadingState: LoadingState = .none {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        
        title = "Видео"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadVideos(flush: true)
    }

    private func loadVideos(flush: Bool) {
        guard loadingState != .loading else {
            return
        }
        
        loadingState = .loading
        
        if flush {
            provider.page = 1
        }
        
        provider.loadVideos { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.mainView.collectionView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let videos):
                if flush {
                    self.objects.removeAll()
                }
                
                self.objects.append(contentsOf: videos.map({ VideoSectionModel(video: $0) }))
                self.loadingState = .loaded
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
                self.loadingState = .failed(error: error)
            }
        }
    }
    
    private func addViewTo(videoId: Int) {
        provider.addViewTo(videoId: videoId) { [weak self] result in
            switch result {
            case .success: break
            case .failure(let error): self?.showError(text: error.localizedDescription)
            }
        }
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    @objc private func pullToRefresh() {
        loadVideos(flush: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension VideosViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = VideosSectionController()
        sectionController.delegate = self

        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyView(loadingState: loadingState)
    }

}

// MARK: - VideosSectionControllerDelegate
extension VideosViewController: VideosSectionControllerDelegate {
    
    func videosSectionController(didSelect video: Video) {
        guard let url = URL(string: video.file) else {
            showError(text: "Не удалось получить ссылку на видео")
            return
        }
        
        playVideo(url: url)
        addViewTo(videoId: video.id)
    }
    
    func videosSectionController(willDisplay cell: UICollectionViewCell, at section: Int) {
        if section + 1 >= objects.count - Constants.pageLimit / 2, loadingState != .loading, provider.page != -1 {
            loadVideos(flush: false)
        }
    }
    
}
