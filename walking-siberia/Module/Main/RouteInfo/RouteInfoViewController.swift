import UIKit
import Atributika
import IGListKit

class RouteInfoViewController: ViewController<RouteInfoView> {
    
    private let provider = RouteInfoProvider()
    
    private var route: Route
    private var objects: [RoutePlaceSectionModel] = []
    private lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        mainView.contentView.likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        mainView.contentView.openMapButton.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        
        adapter.collectionView = mainView.contentView.placesCollectionView
        adapter.dataSource = self
        
        configure()
    }
    
    private func configure() {
        ImageLoader.setImage(url: route.photo, imgView: mainView.contentView.imageView)
        ImageLoader.setImage(url: route.photoMap, imgView: mainView.contentView.mapImageView)
        
        mainView.contentView.titleLabel.text = route.name
        mainView.contentView.descriptionLabel.text = route.routeDescription
        
        objects = route.places.map({ RoutePlaceSectionModel(place: $0) })
        adapter.performUpdates(animated: true)
        
        mainView.contentView.placesTitleLabel.isHidden = objects.isEmpty
        mainView.contentView.placesCollectionView.isHidden = objects.isEmpty
        mainView.contentView.placesCollectionHeightConstraint.update(offset: objects.isEmpty ? 0.0 : 140.0)
        
        updateStats()
    }
    
    private func updateStats() {
        let big = Style("big").font(R.font.geometriaRegular(size: 14.0) ?? .systemFont(ofSize: 14.0))
        mainView.contentView.extentLabel.attributedText = "<big>\(route.km) км</big>\nПротяженность".style(tags: big).attributedString
        mainView.contentView.rateLabel.attributedText = "<big>\(route.countLikes)</big>\nОценили".style(tags: big).attributedString
        mainView.contentView.likeButton.isSelected = route.isLike
    }
    
    @objc private func toggleLike() {
        provider.toggleLike(routeId: route.id) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.route.countLikes += self.route.isLike ? -1 : 1
                self.route.isLike.toggle()
                self.updateStats()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    @objc private func openMap() {
        guard let url = URL(string: route.mapLink) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension RouteInfoViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return RoutePlaceSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
