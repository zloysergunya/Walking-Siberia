import UIKit
import Atributika
import IGListKit
import ImageSlideshow

class RouteInfoViewController: ViewController<RouteInfoView> {
    
    private let provider = RouteInfoProvider()
    
    private var route: Route
    private var objects: [RoutePlaceSectionModel] = []
    private lazy var placesAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
    private var contentView: RouteInfoContentView {
        return mainView.contentView
    }
    
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
        contentView.routeStatsView.likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        contentView.routeStatsView.rateContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleLike)))
        contentView.routeMapView.openMapButton.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        contentView.slideShowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSlideShow)))
        
        placesAdapter.collectionView = contentView.routePlacesView.collectionView
        placesAdapter.dataSource = self
        
        configure()
    }
    
    private func configure() {
        let inputs: [InputSource] = route.photos.compactMap({ URL(string: $0) }).map({ KingfisherSource(url: $0) })
        mainView.contentView.slideShowView.setImageInputs(inputs)
        
        ImageLoader.setImage(url: route.photoMap, imgView: contentView.routeMapView.imageView)
        
        contentView.routeStatsView.titleLabel.text = route.name
        contentView.routeDescriptionView.descriptionLabel.text = route.routeDescription
        
        objects = route.places.map({ RoutePlaceSectionModel(place: $0) })
        placesAdapter.performUpdates(animated: true)
        
        contentView.routePlacesView.isHidden = objects.isEmpty
        
        updateStats()
    }
    
    private func updateStats() {
        let big = Style("big").font(R.font.geometriaRegular(size: 14.0) ?? .systemFont(ofSize: 14.0))
        contentView.routeStatsView.extentLabel.attributedText = "<big>\(route.km) км</big>\nПротяженность".style(tags: big).attributedString
        contentView.routeStatsView.rateLabel.attributedText = "<big>\(route.countLikes)</big>\nОценили".style(tags: big).attributedString
        contentView.routeStatsView.likeButton.isSelected = route.isLike
        contentView.routeStatsView.rateImageView.image = route.isLike ? R.image.likeFill32() : R.image.like32()
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
                Utils.impact()
                
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
    
    @objc private func openSlideShow() {
        contentView.slideShowView.presentFullScreenController(from: self)
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
