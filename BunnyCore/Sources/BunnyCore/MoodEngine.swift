import Foundation

public struct MoodSuggestion: Equatable {
    public let mood: BunnyMood?
    public let message: String
    public let confidence: Double
    public init(mood: BunnyMood?, message: String, confidence: Double) {
        self.mood = mood
        self.message = message
        self.confidence = confidence
    }
}

/// 娱乐性提示规则，不是经过验证的情绪检测器。
public enum MoodEngine {
    public static func suggestion(from reading: HealthReading, restingBaselineBPM: Double,
                                  now: Date = Date()) -> MoodSuggestion {
        let age = now.timeIntervalSince(reading.sampledAt)
        guard age >= 0, age <= 2 * 60 * 60 else {
            return .init(mood: nil, message: "健康数据有点旧，先不猜兔兔的心情。", confidence: 0)
        }
        guard let hr = reading.heartRateBPM else {
            return .init(mood: nil, message: "暂时没有可用的心率样本。", confidence: 0)
        }
        if let hrv = reading.hrvMilliseconds, hr >= restingBaselineBPM + 25, hrv < 35 {
            return .init(mood: .emo, message: "生理信号比较活跃，兔兔先安静陪你一会儿（娱乐参考）。", confidence: 0.45)
        }
        if hr <= restingBaselineBPM + 12 {
            return .init(mood: .neutral, message: "暂时没有明显变化线索，兔兔保持平淡状态。", confidence: 0.35)
        }
        return .init(mood: nil, message: "信号不够明确，兔兔不强行猜心情。", confidence: 0.15)
    }
}
