import UIKit
import SnapKit
import AAInfographics

class UserStatisticView: RootView {
    
    let chatView: AAChartView = {
        let view = AAChartView()
        view.scrollEnabled = false
        view.isClearBackgroundColor = true
        
        return view
    }()
    
    let segmentControl: StyledSegmentedControl = {
        let segmentControl = StyledSegmentedControl(frame: .zero)
        segmentControl.insertSegment(withTitle: "Шаги", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Километры", at: 1, animated: false)
        segmentControl.insertSegment(withTitle: "Калории", at: 2, animated: false)
        segmentControl.selectedSegmentIndex = 0
        
        return segmentControl
    }()
    
    let todayButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Сегодня", for: .normal)
        button.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        button.layer.cornerRadius = 16.0
        button.tag = 0
        
        return button
    }()
    
    let weekButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("7 дней", for: .normal)
        button.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        button.isSelected = true
        button.layer.cornerRadius = 16.0
        button.tag = 1
        
        return button
    }()
    
    let monthButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Месяц", for: .normal)
        button.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        button.isSelected = true
        button.layer.cornerRadius = 16.0
        button.tag = 2
        
        return button
    }()
    
    let yearButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle("Год", for: .normal)
        button.titleLabel?.font = R.font.geometriaMedium(size: 14.0)
        button.isSelected = true
        button.layer.cornerRadius = 16.0
        button.tag = 3
        
        return button
    }()
    
    private lazy var buttonsStackView = UIStackView(views: [
        todayButton,
        weekButton,
        monthButton,
        yearButton
    ], axis: .horizontal, spacing: 8.0, distribution: .fillProportionally)
    
    let stepsCountView = StepsCountView()

    override func setup() {
        backgroundColor = R.color.greyBackground()
        
        addSubview(chatView)
        addSubview(segmentControl)
        addSubview(buttonsStackView)
        addSubview(stepsCountView)
        
        super.setup()
    }
    
    override func setupConstraints() {
        
        chatView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(chatView.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(32.0)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(12.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.height.equalTo(32.0)
        }
        
        stepsCountView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(72.0)
        }
        
    }
    
}
