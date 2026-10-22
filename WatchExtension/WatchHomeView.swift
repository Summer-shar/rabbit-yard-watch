import SwiftUI

struct WatchHomeView: View {
    @State private var mood = "平淡"
    @State private var message = "兔兔正在发呆"
    var body: some View {
        ScrollView {
            VStack(spacing: 9) {
                Text(mood == "emo" ? "🐰☁️" : mood == "美滋滋" ? "🐰✨" : "🐰").font(.system(size: 55))
                Text(mood).font(.headline)
                Text(message).font(.caption2).multilineTextAlignment(.center)
                Button("喂小草 🌱") { mood = "美滋滋"; message = "兔兔吃到小草啦" }.tint(.green)
                Button("送奶茶 🧋") { mood = "美滋滋"; message = "兔兔开心地晃晃耳朵" }.tint(.pink)
                Button("抱抱 ♡") { mood = "美滋滋"; message = "收到抱抱，心里暖暖的" }.tint(.orange)
                Text("界面原型：双端同步待接入").font(.system(size: 8)).foregroundStyle(.secondary)
            }.padding(.horizontal, 5)
        }
    }
}
