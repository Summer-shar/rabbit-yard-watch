import SwiftUI
import Foundation
import WatchKit
import Combine

@main
struct WatchProbeApp: App {
    var body: some Scene {
        WindowGroup {
            WatchProbeView()
        }
    }
}

struct WatchProbeView: View {
    @AppStorage("watchprobe.counter") private var counter = 0
    @State private var remaining = 30
    @State private var isTiming = false
    @State private var isCheckingHTTPS = false
    @State private var httpsStatus = "尚未测试"
    @State private var lastHTTPCode: Int?
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 9) {
                Text("WatchProbe")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("手表基础能力验证")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("本地持久化计数").font(.caption2).foregroundStyle(.secondary)
                    Text("\(counter)")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
                Button {
                    counter += 1
                    WKInterfaceDevice.current().play(.click)
                } label: {
                    Label("计数 +1", systemImage: "plus.circle.fill")
                }
                .tint(.green)

                Button {
                    WKInterfaceDevice.current().play(.success)
                } label: {
                    Label("触觉测试", systemImage: "waveform")
                }
                .tint(.orange)

                Button {
                    if isTiming {
                        isTiming = false
                        WKInterfaceDevice.current().play(.stop)
                    } else {
                        remaining = 30
                        isTiming = true
                        WKInterfaceDevice.current().play(.start)
                    }
                } label: {
                    Label(isTiming ? "停止计时" : "30 秒计时 · \(remaining)s",
                          systemImage: isTiming ? "stop.fill" : "timer")
                }
                .tint(.blue)

                Divider()

                Button {
                    Task { await runHTTPSCheck() }
                } label: {
                    if isCheckingHTTPS {
                        ProgressView()
                    } else {
                        Label("HTTPS 连通性测试", systemImage: "network")
                    }
                }
                .disabled(isCheckingHTTPS)

                Text(httpsStatus)
                    .font(.system(size: 10))
                    .foregroundStyle(httpsStatus.contains("成功") ? Color.green : Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text("不读取健康数据；此版本只验证前台交互与本地状态。")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .onReceive(ticker) { _ in
            guard isTiming else { return }
            if remaining > 0 { remaining -= 1 }
            if remaining == 0 {
                isTiming = false
                WKInterfaceDevice.current().play(.success)
            }
        }
    }

    @MainActor
    private func runHTTPSCheck() async {
        isCheckingHTTPS = true
        httpsStatus = "正在请求 example.com…"
        defer { isCheckingHTTPS = false }
        guard let url = URL(string: "https://example.com") else {
            httpsStatus = "HTTPS 失败：URL 无效"
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 12
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse {
                lastHTTPCode = http.statusCode
                if (200..<400).contains(http.statusCode) {
                    httpsStatus = "HTTPS 成功 · HTTP \(http.statusCode)"
                } else {
                    httpsStatus = "收到 HTTP \(http.statusCode)"
                }
            } else {
                httpsStatus = "连接成功，但没有 HTTP 状态码"
            }
        } catch {
            httpsStatus = "HTTPS 失败 · \(error.localizedDescription)"
        }
    }
}
