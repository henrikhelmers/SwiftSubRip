import RegexBuilder
import Foundation

/// Returns a Subtitle from a String
func makeSubtitle(from inputString: String) -> Subtitle? {
    let from = Reference(TimeInterval.self)
    let to = Reference(TimeInterval.self)
    let text = Reference(String.self)
    
    // Split into named groups
    let entryRegex = Regex {
        OneOrMore(.digit)
        OneOrMore(.whitespace)
        
        Capture(as: from) {
            OneOrMore {
                CharacterClass(
                    .anyOf(":,."),
                    .digit
                )
            }
        } transform: { substring in
            String(substring).timeInterval
        }
        OneOrMore(.whitespace)
        "-->"
        OneOrMore(.whitespace)
        Capture(as: to) {
            OneOrMore {
                CharacterClass(
                    .anyOf(":,."),
                    .digit
                )
            }
        } transform: { substring in
            String(substring).timeInterval
        }
        OneOrMore(.whitespace)
        
        Capture(as: text) {
            OneOrMore(.anyGraphemeCluster)
        } transform: { substring in
            String(substring)
        }
    }
    
    guard let entry = try? entryRegex.wholeMatch(in: inputString) else {
        assertionFailure("Failed to parse regex")
        return nil
    }
    
    return Subtitle(from: entry[from], to: entry[to], text: entry[text])
}


private extension String {
    var timeInterval: TimeInterval {
        let commaToPeriod = replacingOccurrences(of: ",", with: ".")
        let components = commaToPeriod.components(separatedBy: [":"])
        var interval: Double = 0

        for (index, part) in components.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        return interval
    }
}
