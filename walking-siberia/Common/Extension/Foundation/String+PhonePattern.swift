import Foundation

extension String {
    
    func phonePattern(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if pureNumber.first == "9" {
            pureNumber = "7" + pureNumber
        } else if pureNumber.first == "8" {
            pureNumber = "7"
        }
        
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                return pureNumber
            }
            
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            
            guard patternCharacter != replacmentCharacter else {
                continue
            }
            
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
}
