import SwiftUI
import BunnyCore

@main
struct BunnyCompanionApp: App {
    var body: some Scene { WindowGroup { CompanionHomeView().preferredColorScheme(.light) } }
}

struct CompanionHomeView: View {
    @State private var mood: BunnyMood = .neutral
    @State private var joy = 60
    @State private var feedCount = 0
    @State private var note = BunnyMood.neutral.note
    private let ink = Color(red: 0.32, green: 0.25, blue: 0.23)
    private let cream = Color(red: 0.99, green: 0.95, blue: 0.88)
    private let mint = Color(red: 0.84, green: 0.95, blue: 0.88)

    var body: some View {
        ZStack {
            LinearGradient(colors: [cream, mint], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("兔兔陪伴").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ink.opacity(0.65))
                            Text("今天也要好好的").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(ink)
                        }
                        Spacer()
                        Image(systemName: "heart.text.square.fill").font(.title2).foregroundStyle(ink.opacity(0.7))
                    }
                    VStack(spacing: 12) {
                        HStack {
                            Label("兔兔现在的心情", systemImage: mood == .happy ? "sun.max.fill" : "cloud")
                                .font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(ink.opacity(0.7))
                            Spacer()
                            Text(mood.title).font(.system(size: 13, weight: .bold, design: .rounded))
                                .padding(.horizontal, 12).padding(.vertical, 7).background(moodTint, in: Capsule()).foregroundStyle(ink)
                        }
                        Text(mood == .emo ? "🐰☁️" : mood == .happy ? "🐰✨" : "🐰")
                            .font(.system(size: 108)).frame(maxWidth: .infinity).padding(.vertical, 5)
                        Text(mood == .emo ? "想安静待一会儿" : mood == .happy ? "兔兔美滋滋！" : "兔兔正在发呆")
                            .font(.system(size: 21, weight: .bold, design: .rounded)).foregroundStyle(ink)
                        Text(note).font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(ink.opacity(0.65)).multilineTextAlignment(.center)
                        HStack {
                            Label("开心值 \(joy)", systemImage: "heart.fill")
                            Spacer()
                            Label("礼物 \(feedCount)", systemImage: "gift.fill")
                        }.font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(ink.opacity(0.65))
                    }.padding(18).frame(maxWidth: .infinity)
                        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 27, style: .continuous))
                    VStack(alignment: .leading, spacing: 10) {
                        Text("今天是什么心情？").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundStyle(ink)
                        HStack(spacing: 9) {
                            moodButton(.emo, emoji: "☁️")
                            moodButton(.neutral, emoji: "🌤️")
                            moodButton(.happy, emoji: "✨")
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("给兔兔一点小开心").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundStyle(ink)
                        HStack(spacing: 10) {
                            ForEach(BunnyFood.allCases) { food in
                                Button {
                                    feedCount += 1
                                    joy = min(100, joy + (food == .grass ? 8 : 12))
                                    mood = .happy
                                    note = food.feedback
                                } label: {
                                    VStack(spacing: 7) {
                                        Text(food.emoji).font(.system(size: 30))
                                        Text(food.title).font(.system(size: 12, weight: .semibold, design: .rounded))
                                    }.foregroundStyle(ink).frame(maxWidth: .infinity).padding(.vertical, 14)
                                        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Apple Watch 联动", systemImage: "applewatch").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(ink)
                        Text("这是可交互的界面原型。下一步接入手表状态同步与 HealthKit。")
                            .font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(ink.opacity(0.65))
                    }.padding(16).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                }.padding(20).frame(maxWidth: 560).frame(maxWidth: .infinity)
            }
        }
    }

    private func moodButton(_ value: BunnyMood, emoji: String) -> some View {
        Button {
            mood = value
            note = value.note
        } label: {
            VStack(spacing: 7) {
                Text(emoji).font(.system(size: 25))
                Text(value.title).font(.system(size: 13, weight: .bold, design: .rounded))
            }.foregroundStyle(ink).frame(maxWidth: .infinity).padding(.vertical, 13)
                .background(mood == value ? moodTint : .white.opacity(0.72), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }.buttonStyle(.plain)
    }

    private var moodTint: Color {
        switch mood {
        case .emo: return Color(red: 0.96, green: 0.82, blue: 0.82)
        case .neutral: return Color(red: 0.88, green: 0.92, blue: 0.82)
        case .happy: return Color(red: 0.99, green: 0.87, blue: 0.62)
        }
    }
}
