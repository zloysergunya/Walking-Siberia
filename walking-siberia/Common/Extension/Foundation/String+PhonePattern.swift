import Foundation

extension String {
    
    func phonePattern(pattern: String, replacmentCharacter: Character) -> String {
        var numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if numbers.first == "9" {
            numbers = "7" + numbers
        } else if numbers.first == "8" {
            numbers = "7"
        }
        
        var result = ""
        var index = numbers.startIndex
        
        for ch in pattern where index < numbers.endIndex {
            if ch == replacmentCharacter {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    
}
