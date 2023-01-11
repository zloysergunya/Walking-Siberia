import UIKit
import SwiftLoader
import SwiftyMenu

enum DropDownType {
    case routes, trainers
}

final class CityDropDownView: DropDownView {

    private let provider = CityDropDownProvider()
    private var allCities = RouteCity(id: 0, name: "")
    
    convenience init(type: DropDownType) {
        self.init(frame: .zero)
        
        switch type {
        case .routes:
            allCities.name = "Все маршруты"
        case .trainers:
            allCities.name = "Все тренеры"
        }
        
        items = [allCities]
        DispatchQueue.main.async {
            self.selectedIndex = 0
        }

        loadCities()
    }
    
    private func loadCities() {
        provider.loadCities { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var cities):
                cities.insert(self.allCities, at: 0)
                self.items = cities
                if let userCity = UserSettings.user?.profile.city,
                   let index = cities.firstIndex(where: { $0.name == userCity }) {
                    self.selectedIndex = index
                    self.delegate?.dropDownView(self, didSelect: self.items[index], at: index)
                }
                
            case .failure(let error):
                if case .error(let status, _, _) = error.err,
                   error._code != NSURLErrorTimedOut,
                   ![500, 503].contains(status) {
                    //SwiftLoader.show(title: error.localizedDescription, animated: true)
                }
            }
        }
    }
    
}
