import AVKit
import RegexBuilder

public struct Subtitle {
    let from: Double
    let to: Double
    let text: String
    var interval: ClosedRange<Double> {
        from...to
    }
}

public struct Subtitles {
    var entries: [Subtitle]

    /// File expected to have UTF-8 encoding
    init(from url: URL) throws {
        let string = try String(contentsOf: url)
        entries = try parseSubRip(string)
    }

    func getSubtitle(at timeStamp: TimeInterval) -> Subtitle? {
        entries.first(where: {
            $0.interval.contains(timeStamp)
        })
    }
}

private func parseSubRip(_ payload: String) throws -> [Subtitle] {
    // Recognize the SubRip format

    let regex = try! Regex(#"([0-9]+)\n([[0-9]:,.]+)\s+-{2}\>\s+([[0-9]:,.]+)\n([\s\S]*?(?=\n{2,}|$))"#)


    // Split entry into named groups
    let index = Reference(Substring.self)
    let from = Reference(Substring.self)
    let to = Reference(Substring.self)
    let text = Reference(Substring.self)

    // 1
    // 00:00:01,240 --> 00:00:05,080
    // Dette her er TIDENES MOMENTO!!!
    let entryRegex = Regex {
        Capture(as: index) {
            OneOrMore(.digit)
        }
        OneOrMore(.whitespace)

        Capture(as: from) {
            OneOrMore {
                CharacterClass(
                    .anyOf(":,."),
                    .digit
                )
            }
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
        }
        OneOrMore(.whitespace)

        Capture(as: text) {
            OneOrMore(.anyGraphemeCluster)
        }
    }

    return payload.ranges(of: regex).compactMap {

        guard let entry = try? entryRegex.wholeMatch(in: payload[$0]) else {
            fatalError("Beep boop")
        }

        return Subtitle(from: String(entry[from]).timeInterval,
                        to: String(entry[to]).timeInterval,
                        text: String(entry[text]))
    }
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
