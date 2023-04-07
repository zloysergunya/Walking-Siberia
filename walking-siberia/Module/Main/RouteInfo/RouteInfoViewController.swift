import UIKit
import Atributika
import IGListKit
import ImageSlideshow

class RouteInfoViewController: ViewController<RouteInfoView> {
    
    private let provider = RouteInfoProvider()
    
    private var route: Route
    private var places: [Place] = []
    private var reviews: [RouteReview] = []
    private lazy var placesAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    private lazy var reviewsAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    
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
        contentView.writeReviewButton.addTarget(self, action: #selector(openAddReview), for: .touchUpInside)
        
        placesAdapter.collectionView = contentView.routePlacesView.collectionView
        placesAdapter.dataSource = self
        
        reviewsAdapter.collectionView = contentView.routeReviewsView.collectionView
        reviewsAdapter.dataSource = self
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configure() {
        let inputs: [InputSource] = route.photos.compactMap({ URL(string: $0) }).map({ KingfisherSource(url: $0) })
        mainView.contentView.slideShowView.setImageInputs(inputs)
        
        ImageLoader.setImage(url: route.photoMap, imgView: contentView.routeMapView.imageView)
        
        contentView.routeStatsView.titleLabel.text = route.name
        contentView.routeDescriptionView.descriptionLabel.text = route.routeDescription
        
        places = route.places
        placesAdapter.performUpdates(animated: true)
        
        reviews = route.comments ?? []
        reviewsAdapter.performUpdates(animated: true)
        
        contentView.routePlacesView.isHidden = places.isEmpty
        contentView.routeReviewsView.isHidden = reviews.isEmpty
        
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
    
    @objc private func openAddReview() {
        let viewController = AddReviewViewController(route: route)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ListAdapterDataSource
extension RouteInfoViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch listAdapter {
        case placesAdapter:
            return places.map({ RoutePlaceSectionModel(place: $0) })
        case reviewsAdapter:
            return reviews.map({ RouteReviewSectionModel(routeReview: $0) })
        default:
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch listAdapter {
        case placesAdapter:
            return RoutePlaceSectionController()
        case reviewsAdapter:
            let sectionController = RouteReviewSectionController()
            sectionController.delegate = self
            
            return sectionController
        default:
            return .init()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - RouteReviewSectionControllerDelegate
extension RouteInfoViewController: RouteReviewSectionControllerDelegate {
    func routeReviewSectionController(_ sectionController: RouteReviewSectionController, didSelectItemAt index: Int) {
        let viewController = ReviewDetailsViewController(route: route, review: reviews[index])
        navigationController?.pushViewController(viewController, animated: true)
    }
}
