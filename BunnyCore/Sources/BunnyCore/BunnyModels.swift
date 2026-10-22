import Foundation

public enum BunnyMood: String, Codable, CaseIterable, Identifiable {
    case emo, neutral, happy
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .emo: return "emo"
        case .neutral: return "平淡"
        case .happy: return "美滋滋"
        }
    }
    public var note: String {
        switch self {
        case .emo: return "兔兔想安静待一会儿。"
        case .neutral: return "兔兔正在发呆，等一会儿可能会伸懒腰。"
        case .happy: return "兔兔美滋滋，可能忍不住蹦跶两下。"
        }
    }
}

public enum BunnyFood: String, Codable, CaseIterable, Identifiable {
    case grass, milkTea, flower
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .grass: return "小草"
        case .milkTea: return "虚拟奶茶"
        case .flower: return "小花"
        }
    }
    public var emoji: String {
        switch self {
        case .grass: return "🌱"
        case .milkTea: return "🧋"
        case .flower: return "🌸"
        }
    }
    public var feedback: String {
        switch self {
        case .grass: return "兔兔咔嚓咔嚓吃完了小草。"
        case .milkTea: return "收到虚拟奶茶，兔兔开心地晃晃耳朵。"
        case .flower: return "兔兔收到一朵小花，悄悄开心了一会儿。"
        }
    }
}

public struct HealthReading: Codable, Equatable {
    public var heartRateBPM: Double?
    public var hrvMilliseconds: Double?
    public var sampledAt: Date
    public init(heartRateBPM: Double?, hrvMilliseconds: Double?, sampledAt: Date = Date()) {
        self.heartRateBPM = heartRateBPM
        self.hrvMilliseconds = hrvMilliseconds
        self.sampledAt = sampledAt
    }
}

public struct BunnySnapshot: Codable, Equatable {
    public var mood: BunnyMood
    public var bunnyIndex: Int
    public var joy: Int
    public var feedCount: Int
    public var lastFood: BunnyFood?
    public var updatedAt: Date
    public var heartRateBPM: Double?
    public var hrvMilliseconds: Double?
    public var moodNote: String

    public init(mood: BunnyMood = .neutral, bunnyIndex: Int = 0, joy: Int = 60,
                feedCount: Int = 0, lastFood: BunnyFood? = nil, updatedAt: Date = Date(),
                heartRateBPM: Double? = nil, hrvMilliseconds: Double? = nil,
                moodNote: String = BunnyMood.neutral.note) {
        self.mood = mood
        self.bunnyIndex = min(max(bunnyIndex, 0), 8)
        self.joy = min(max(joy, 0), 100)
        self.feedCount = max(feedCount, 0)
        self.lastFood = lastFood
        self.updatedAt = updatedAt
        self.heartRateBPM = heartRateBPM
        self.hrvMilliseconds = hrvMilliseconds
        self.moodNote = moodNote
    }

    public mutating func setMood(_ value: BunnyMood, note: String? = nil) {
        mood = value
        moodNote = note ?? value.note
        updatedAt = Date()
    }

    public mutating func feed(_ food: BunnyFood) {
        feedCount += 1
        joy = min(100, joy + (food == .grass ? 8 : 12))
        lastFood = food
        setMood(.happy, note: food.feedback)
    }

    public var imageName: String { String(format: "Bunny%02d", bunnyIndex + 1) }

    public func payload() -> [String: Any] {
        var p: [String: Any] = [
            "mood": mood.rawValue, "bunnyIndex": bunnyIndex, "joy": joy,
            "feedCount": feedCount, "lastFood": lastFood?.rawValue ?? "",
            "updatedAt": updatedAt.timeIntervalSince1970, "moodNote": moodNote
        ]
        if let heartRateBPM { p["heartRateBPM"] = heartRateBPM }
        if let hrvMilliseconds { p["hrvMilliseconds"] = hrvMilliseconds }
        return p
    }

    public init?(payload: [String: Any]) {
        guard let raw = payload["mood"] as? String, let mood = BunnyMood(rawValue: raw) else { return nil }
        self.init(
            mood: mood, bunnyIndex: payload["bunnyIndex"] as? Int ?? 0,
            joy: payload["joy"] as? Int ?? 60, feedCount: payload["feedCount"] as? Int ?? 0,
            lastFood: BunnyFood(rawValue: payload["lastFood"] as? String ?? ""),
            updatedAt: Date(timeIntervalSince1970: payload["updatedAt"] as? Double ?? Date().timeIntervalSince1970),
            heartRateBPM: payload["heartRateBPM"] as? Double,
            hrvMilliseconds: payload["hrvMilliseconds"] as? Double,
            moodNote: payload["moodNote"] as? String ?? mood.note
        )
    }
}
