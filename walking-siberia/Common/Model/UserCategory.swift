import Foundation

enum UserCategory: Int {
    case schoolchild = 10
    case student = 20
    case adult = 30
    case pensioner = 40
    case manWithHIA = 50
    
    var categoryName: String {
        switch self {
        case .schoolchild: return "Дети"
        case .student: return "Молодежь"
        case .adult: return "Взрослые"
        case .pensioner: return "Старшее поколение"
        case .manWithHIA: return "Люди с ОВЗ"
        }
    }
}
