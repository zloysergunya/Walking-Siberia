import UIKit
import AAInfographics

class UserStatisticViewController: ViewController<UserStatisticView> {
    
    enum StatisticPeriod: Int {
        case today, week, month, year
    }
    
    private let user: User
    private let provider = UserStatisticProvider()
    
    private var statistic: Statistic? = UserSettings.statistic
    private var period: StatisticPeriod? = .today
    private var periodButtons: [ActiveButton] {
        return [mainView.todayButton, mainView.weekButton, mainView.monthButton, mainView.yearButton]
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        title = user.userId == UserSettings.user?.userId ? "Моя" : "\(user.profile.firstName) \(user.profile.lastName)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.segmentControl.addTarget(self, action: #selector(segmentControlUpdated), for: .valueChanged)
        periodButtons.forEach({ $0.addTarget(self, action: #selector(changePeriod), for: .touchUpInside) })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWalkChart()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func loadWalkChart() {
        provider.loadWalkChart(userId: user.userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let statistic):
                if self.user.userId == UserSettings.user?.userId {
                    UserSettings.statistic = statistic
                }
                
                self.statistic = statistic
                self.updateChart()
                self.updateTotalStat()
                
            case .failure(let error):
                self.showError(text: error.localizedDescription)
            }
        }
    }
    
    private func updateChart() {
        guard let period = period,
              let statistic = statistic
        else { return }
        
        let days: [Day]
        switch period {
        case .today: days = statistic.day
        case .week: days = statistic.week
        case .month: days = statistic.month
        case .year: days = statistic.year
        }
        
        var data: [Any] = []
        days.forEach { day in
            switch mainView.segmentControl.selectedSegmentIndex {
            case 0: data.append([day.date, Double(day.number)])
            case 1: data.append([day.date, day.km])
            case 2: data.append([day.date, day.calories])
            default: break
            }
        }
        
        let element = AASeriesElement()
        element.color = AAGradientColor.linearGradient(startColor: "#69CEF5", endColor: "#2DA6DE")
        
        let name: String
        switch mainView.segmentControl.selectedSegmentIndex {
        case 0: name = "Шаги"
        case 1: name = "Километры"
        case 2: name = "Калории"
        default: name = ""
        }
        element.name(name)
        element.data(data)
        
        let chartModel = AAChartModel()
        chartModel.legendEnabled = false
        chartModel.chartType = .column
        chartModel.series = [element]
        chartModel.categories = createCategories(for: period, days: days)
        mainView.chatView.aa_drawChartWithChartModel(chartModel)
    }
    
    private func createCategories(for period: StatisticPeriod, days: [Day]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let dates = days.compactMap({ dateFormatter.date(from: $0.date) })
        
        switch period {
        case .today:
            return ["Сегодня"]
            
        case .week:
            dateFormatter.dateFormat = "EEE"
            
        case .month:
            dateFormatter.dateFormat = "dd.MM"
            
        case .year:
            dateFormatter.dateFormat = "LLLL"
        }
        
        return dates.map({ dateFormatter.string(from: $0) })
    }
    
    private func updateTotalStat() {
        guard let period = period, let statistic = statistic else {
            return
        }
        
        let days: [Day]
        switch period {
        case .today: days = statistic.day
        case .week: days = statistic.week
        case .month: days = statistic.month
        case .year: days = statistic.year
        }
        
        let steps = days.map({ $0.number }).reduce(0, +)
        let distance = days.map({ $0.km }).reduce(0, +)
        
        mainView.stepsCountView.setup(with: steps, distance: distance)
    }
    
    @objc private func changePeriod(_ sender: ActiveButton) {
        periodButtons.forEach { button in
            button.isSelected = sender.tag != button.tag
            
            if !button.isSelected {
                period = .init(rawValue: button.tag)
            }
        }
        
        updateChart()
        updateTotalStat()
    }
    
    @objc private func segmentControlUpdated() {
        updateChart()
    }
    
}
