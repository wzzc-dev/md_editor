import Cocoa
import FlutterMacOS
import os

private let benchmarkSignpostLog = OSLog(subsystem: "md_editor.benchmark", category: .pointsOfInterest)

@_cdecl("md_editor_benchmark_signpost_event")
public func mdEditorBenchmarkSignpostEvent(_ actionID: Int32) {
  os_log("md_editor_action id=%d", log: benchmarkSignpostLog, type: .default, actionID)
  os_signpost(.event, log: benchmarkSignpostLog, name: "md_editor_action", "%d", actionID)
}

@main
class AppDelegate: FlutterAppDelegate {
  override public init() {
    // 统一口径（进程起点 → 首帧可交互）：最早的 Swift 时刻打点，经环境
    // 变量传给 Dart 侧的 first_interactive 计算。Flutter 引擎在此之后
    // 才拉起，Dart 的 Platform.environment 能读到该值。
    let epochMs = Int(Date().timeIntervalSince1970 * 1000)
    setenv("MD_BENCHMARK_START_EPOCH", String(epochMs), 1)
    super.init()
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
