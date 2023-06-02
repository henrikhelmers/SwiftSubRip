import XCTest
@testable import swift_subrip

final class swift_subripTests: XCTestCase {
    func testParser() throws {
        let url = Bundle.module.url(forResource: "sample1", withExtension: "srt")!

        let subtitles = try! Subtitles(from: url)

        print(subtitles)

        // XCTAssertEqual(swift_subrip().text, "Hello, World!")
    }
}
