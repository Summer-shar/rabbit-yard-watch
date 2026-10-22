# 兔兔陪伴｜iPhone + Apple Watch

独立的原生 iOS + watchOS 小兔子陪伴应用，与 Windows 桌宠、兔兔小院完全独立。

## 当前 GitHub 原型
- iPhone SwiftUI 交互界面：三种心情、投喂小草/虚拟奶茶/小花、开心值和礼物计数。
- Apple Watch 界面概念源码：快捷投喂与抱抱（目前为 UI 原型，尚未接入 watchOS target）。
- BunnyCore 共享模型与娱乐性心情规则，包含单元测试。
- GitHub Actions 在 macOS 上运行共享核心测试、构建 iOS Simulator app，并尝试截取真实模拟器截图。

## 当前限制
当前 GitHub 原型优先验证 iPhone UI 和共享逻辑。Watch App 的 Xcode target、WatchConnectivity、HealthKit 真机读取与动作帧尚未完成。模拟器截图是实际运行的 iOS Simulator 画面，不代表已经可安装到真实设备或已完成 Apple Watch 联动。

## 开发环境
需要 macOS、Xcode 与 XcodeGen。不要把 Apple ID 密码、签名证书、描述文件或健康数据提交到仓库。