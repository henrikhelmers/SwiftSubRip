import XCTest
@testable import swift_subrip

final class swift_subripTests: XCTestCase {
    let urls = ["sample1", "sample2"].compactMap {
        Bundle.module.url(forResource: $0, withExtension: "srt")
    }
    
    func testOutput() throws {
        urls.forEach {
            XCTAssertNotNil(try? Subtitles(from: $0))
        }
    }
    
    func testPerformance() {
        measure {
            urls.forEach {
                let _ = try? Subtitles(from: $0)
            }
        }
    }
}
