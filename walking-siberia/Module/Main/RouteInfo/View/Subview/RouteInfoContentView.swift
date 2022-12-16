import UIKit
import SnapKit
import ImageSlideshow

class RouteInfoContentView: RootView {
    
    let slideShowView: ImageSlideshow = {
        let view = ImageSlideshow()
        view.contentScaleMode = .scaleAspectFill
        view.zoomEnabled = true
        view.layer.cornerRadius = 6.0
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = R.color.grey()
        view.pageIndicator = pageControl
        
        return view
    }()
    
    let routeStatsView = RouteStatsView()
    let routeMapView = RouteMapView()
    let routeDescriptionView = RouteDescriptionView()
    let routePlacesView = RoutePlacesView()
    
    let writeReviewButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Написать отзыв", for: .normal)
        
        return button
    }()
    
    private lazy var rootStack = UIStackView(views: [
        slideShowView,
        routeStatsView,
        routeMapView,
        routeDescriptionView,
        routePlacesView,
        writeReviewButton
    ], spacing: 16.0, distribution: .fill)
    
    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(rootStack)
        
        super.setup()
    }
    
    override func setupConstraints() {
        slideShowView.snp.makeConstraints { make in
            make.width.equalTo(slideShowView.snp.height).multipliedBy(1.0 / 1.0)
        }
        
        rootStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
