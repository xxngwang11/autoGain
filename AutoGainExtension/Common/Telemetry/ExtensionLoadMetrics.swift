import Foundation

enum ExtensionLoadEvent: String, CaseIterable {
    case loadStart = "load_start"
    case auInit = "au_init"
    case allocateRenderResources = "allocate_render_resources"
    case firstRender = "first_render"
    case uiReady = "ui_ready"
}

final class ExtensionLoadMetrics {
    static let shared = ExtensionLoadMetrics()

    private let lock = NSLock()
    private var times: [ExtensionLoadEvent: UInt64] = [:]
    private var didDumpSummary = false

    private init() {}

    func mark(_ event: ExtensionLoadEvent) {
        let now = DispatchTime.now().uptimeNanoseconds

        lock.lock()
        defer { lock.unlock() }

        if times[event] != nil { return }

        if times[.loadStart] == nil && event != .loadStart {
            times[.loadStart] = now
        }

        times[event] = now

        let start = times[.loadStart] ?? now
        let elapsedMs = Double(now - start) / 1_000_000.0
        let formatted = String(format: "%.3f", elapsedMs)
        print('[AULoad][Extension] \(event.rawValue) +\(formatted)ms')

        if (event == .uiReady || event == .firstRender) && !didDumpSummary {
            didDumpSummary = true
            dumpSummary()
        }
    }

    func elapsed(from: ExtensionLoadEvent, to: ExtensionLoadEvent) -> Double? {
        guard let start = times[from], let end = times[to] else { return nil }
        return Double(end - start) / 1_000_000.0
    }

    private func dumpSummary() {
        let pairs: [(ExtensionLoadEvent, ExtensionLoadEvent, String)] = [
            (.loadStart, .auInit, "loadStart -> auInit"),
            (.loadStart, .allocateRenderResources, "loadStart -> allocateRenderResources"),
            (.loadStart, .firstRender, "loadStart -> firstRender"),
            (.loadStart, .uiReady, "loadStart -> uiReady")
        ]

        print('[AULoad][Extension] ---- summary ----')
        for (from, to, label) in pairs {
            if let ms = elapsed(from: from, to: to) {
                let formatted = String(format: "%.3f", ms)
                print('[AULoad][Extension] \(label): \(formatted)ms')
            }
        }
        print('[AULoad][Extension] -----------------')
    }
}