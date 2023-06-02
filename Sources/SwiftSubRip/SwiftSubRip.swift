import AVKit
import RegexBuilder

public struct Subtitle {
    public let from: Double
    public let to: Double
    public let text: String
    public var interval: ClosedRange<Double> {
        from...to
    }
}

public struct Subtitles {
    var entries: [Subtitle]

    /// File expected to have UTF-8 encoding
    public init?(from url: URL) {
        guard let string = try? String(contentsOf: url),
              let parsedStrings = try? parseSubRip(string) else {
                  return nil
              }        
        entries = parsedStrings
    }

    public func getSubtitle(at timeStamp: TimeInterval) -> Subtitle? {
        entries.first(where: {
            $0.interval.contains(timeStamp)
        })
    }
}

private func parseSubRip(_ payload: String) throws -> [Subtitle] {

    // Recognize the SubRip format
    let regex = Regex {
        Capture {
            OneOrMore(.digit)
            OneOrMore(.whitespace)

            OneOrMore(
                CharacterClass(
                    .anyOf(":,."),
                    .digit
                )
            )
            OneOrMore(.whitespace)

            "-->"
            OneOrMore(.whitespace)

            OneOrMore(
                CharacterClass(
                    .anyOf(":,."),
                    .digit
                )
            )
            OneOrMore(.whitespace)

            OneOrMore(.anyGraphemeCluster)
        }
        OneOrMore(.whitespace)
    }


    // Split entry into named groups
    let from = Reference(TimeInterval.self)
    let to = Reference(TimeInterval.self)
    let text = Reference(String.self)
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

    return payload.ranges(of: regex).compactMap {
        guard let entry = try? entryRegex.wholeMatch(in: payload[$0]) else {
            fatalError("Beep boop")
        }

        return Subtitle(from: entry[from], to: entry[to], text: entry[text])
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
