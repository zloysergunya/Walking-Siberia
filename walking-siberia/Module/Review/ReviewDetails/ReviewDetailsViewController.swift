import UIKit

class ReviewDetailsViewController: ViewController<ReviewDetailsView> {
    
    private let route: Route
    private let review: RouteReview
    
    init(route: Route, review: RouteReview) {
        self.route = route
        self.review = review
        super.init(nibName: nil, bundle: nil)
        
        title = "Отзыв"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        mainView.nameLabel.text = route.name
        mainView.textLabel.text = review.text
        mainView.usernameLabel.text = review.username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
