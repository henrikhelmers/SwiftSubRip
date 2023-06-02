import XCTest
@testable import SwiftSubRip

final class swift_subripTests: XCTestCase {
    let urls = ["sample1", "sample2"].compactMap {
        Bundle.module.url(forResource: $0, withExtension: "srt")
    }
    
    func testOutput() throws {
        urls.forEach {
            XCTAssertNotNil(Subtitles(from: $0))
        }
    }
    
    func testPerformance() {
        measure {
            urls.forEach {
                let _ = Subtitles(from: $0)
            }
        }
    }
}
