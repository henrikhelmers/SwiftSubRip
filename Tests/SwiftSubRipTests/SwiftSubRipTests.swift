import XCTest
@testable import SwiftSubRip

final class swift_subripTests: XCTestCase {
    // From sample1. Keep in mind if test fail after changing
    let matchText = "Where dreams and hopes doth flow,"
    let urls = ["sample1", "sample2"].compactMap {
        Bundle.module.url(forResource: $0, withExtension: "srt")
    }

    func testOutput() throws {
        urls.forEach {
            XCTAssertNotNil(Subtitles(from: $0))
        }
    }
    
    func testGetSubtitleAtTimeInterval() throws {
        guard let firstUrl = urls.first,
              let subtitles = Subtitles(from: firstUrl) else {
            XCTAssert(false)
            return
        }
        let text = subtitles.getSubtitle(at: 5.0)?.text
        XCTAssertNotNil(text)
        XCTAssertEqual(text, matchText)
    }

    
    func testGetWrongSubtitleAtTimeInterval() throws {
        guard let firstUrl = urls.first,
              let subtitles = Subtitles(from: firstUrl) else {
            XCTAssert(false)
            return
        }
        let text = subtitles.getSubtitle(at: 3.0)?.text
        XCTAssertNotNil(text)
        XCTAssertNotEqual(text, matchText)
    }

    
    func testPerformance() {
        measure {
            urls.forEach {
                let _ = Subtitles(from: $0)
            }
        }
    }
}
