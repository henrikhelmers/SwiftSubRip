import Foundation
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
              let subtitles = parseSubRip(string) else {
                  return nil
              }        
        entries = subtitles
    }

    public func getSubtitle(at timeStamp: TimeInterval) -> Subtitle? {
        entries.first(where: {
            return $0.interval.contains(timeStamp)
        })
    }
}

func parseSubRip(_ text: String) -> [Subtitle]? {
    let subtitles = text.split(separator: "\n\n").compactMap {
        return makeSubtitle(from: String($0))
    }
    return subtitles.isEmpty ? nil : subtitles
}
