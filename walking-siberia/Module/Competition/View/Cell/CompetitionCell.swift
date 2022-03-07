import UIKit
import SnapKit

class CompetitionCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaMedium(size: 14.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let teamsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 10.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    let datesLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.geometriaRegular(size: 12.0)
        label.textColor = R.color.mainContent()
        
        return label
    }()
    
    private let calendarImageView = UIImageView(image: R.image.calendar16())
    private let chevronImageView = UIImageView(image: R.image.chevronRight24())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.0
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(teamsLabel)
        contentView.addSubview(datesLabel)
        contentView.addSubview(calendarImageView)
        contentView.addSubview(chevronImageView)
        
        addShadow()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.left.equalToSuperview().offset(12.0)
            make.right.equalTo(chevronImageView.snp.left).offset(-8.0)
        }
        
        teamsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalToSuperview().offset(12.0)
            make.right.equalTo(chevronImageView.snp.left).offset(-8.0)
        }
        
        datesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarImageView.snp.centerY)
            make.left.equalTo(calendarImageView.snp.right).offset(4.0)
            make.right.equalTo(chevronImageView.snp.left).offset(-8.0)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.size.equalTo(16.0)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-4.0)
            make.size.equalTo(24.0)
        }
        
    }
    
}
