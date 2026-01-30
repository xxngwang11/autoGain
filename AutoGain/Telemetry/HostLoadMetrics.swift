import Foundation

enum HostLoadEvent: String {
    case loadStart = "load_start"
    case viewModelReady = "view_model_ready"
}

final class HostLoadMetrics {
    static let shared = HostLoadMetrics()

    private let lock = NSLock()
    private var times: [HostLoadEvent: UInt64] = [:]

    private init() {}

    func mark(_ event: HostLoadEvent) {
        let now = DispatchTime.now().uptimeNanoseconds

        lock.lock()
        defer { lock.unlock() }

        if times[event] != nil { return }
        times[event] = now

        if let start = times[.loadStart] {
            let elapsedMs = Double(now - start) / 1_000_000.0
            let formatted = String(format: "%.3f", elapsedMs)
            print("[AULoad][Host] \(event.rawValue) +\(formatted)ms")
        } else {
            print("[AULoad][Host] \(event.rawValue)")
        }
    }
}