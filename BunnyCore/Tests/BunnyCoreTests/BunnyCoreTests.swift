import XCTest
@testable import BunnyCore

final class BunnyCoreTests: XCTestCase {
    func testFeedingMakesBunnyHappy() {
        var s = BunnySnapshot()
        s.feed(.grass)
        XCTAssertEqual(s.mood, .happy)
        XCTAssertEqual(s.feedCount, 1)
        XCTAssertEqual(s.joy, 68)
    }
    func testPayloadRoundTrip() {
        let s = BunnySnapshot(mood: .emo, bunnyIndex: 4, joy: 31)
        let r = BunnySnapshot(payload: s.payload())
        XCTAssertEqual(r?.mood, .emo)
        XCTAssertEqual(r?.bunnyIndex, 4)
    }
    func testOldHealthSampleDoesNotGuess() {
        let r = HealthReading(heartRateBPM: 120, hrvMilliseconds: 20,
                              sampledAt: Date().addingTimeInterval(-3 * 60 * 60))
        XCTAssertNil(MoodEngine.suggestion(from: r, restingBaselineBPM: 70).mood)
    }
    func testAmbiguousSampleDoesNotForceMood() {
        let r = HealthReading(heartRateBPM: 92, hrvMilliseconds: 48)
        XCTAssertNil(MoodEngine.suggestion(from: r, restingBaselineBPM: 70).mood)
    }
}
