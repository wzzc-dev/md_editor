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
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
