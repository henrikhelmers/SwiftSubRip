import Foundation

extension String {
    var timeInterval: TimeInterval {
        let components = replacingOccurrences(of: ",", with: ".")
            .components(separatedBy: [":"])
        var interval: Double = .zero

        for (index, part) in components.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        return interval
    }
}
