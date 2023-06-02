import RegexBuilder
import Foundation

/// Returns a Subtitle from a String
func makeSubtitle(from inputString: String) -> Subtitle? {
    let from = Reference(TimeInterval.self)
    let to = Reference(TimeInterval.self)
    let text = Reference(String.self)
    
    let regex = Regex {
        OneOrMore(.digit)
        OneOrMore(.whitespace)
        Capture(as: from) {
            OneOrMore {
                CharacterClass(.anyOf(":,."), .digit)
            }
        } transform: { String($0).timeInterval }
        " --> "
        Capture(as: to) {
            OneOrMore {
                CharacterClass(.anyOf(":,."), .digit)
            }
        } transform: { String($0).timeInterval}
        OneOrMore(.whitespace)
        Capture(as: text) {
            OneOrMore(.anyGraphemeCluster)
        } transform: { String($0) }
    }
    
    guard let entry = try? regex.wholeMatch(in: inputString) else {
        assertionFailure("Failed to match regex")
        return nil
    }
    
    return Subtitle(from: entry[from], to: entry[to], text: entry[text])
}
