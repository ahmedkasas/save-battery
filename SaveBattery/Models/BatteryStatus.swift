import Foundation

struct BatteryStatus: Equatable {
    enum State: String {
        case unknown
        case unplugged
        case charging
        case full

        var localizedDescriptionKey: String {
            switch self {
            case .unknown: return "battery_state_unknown"
            case .unplugged: return "battery_state_unplugged"
            case .charging: return "battery_state_charging"
            case .full: return "battery_state_full"
            }
        }
    }

    var level: Float
    var state: State
    var isLowPowerModeEnabled: Bool

    var levelPercentText: String {
        guard level >= 0 else { return "--%" }
        return "\(Int((level * 100).rounded()))%"
    }
}
