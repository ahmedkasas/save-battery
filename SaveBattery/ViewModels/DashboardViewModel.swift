import Foundation
import UIKit
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var status: BatteryStatus

    private var cancellables = Set<AnyCancellable>()

    init(batteryMonitor: BatteryMonitorService = .shared) {
        self.status = batteryMonitor.status
        batteryMonitor.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.status = $0 }
            .store(in: &cancellables)
    }

    var levelPercentText: String { status.levelPercentText }
    var stateDescriptionKey: String { status.state.localizedDescriptionKey }
    var isLowPowerModeEnabled: Bool { status.isLowPowerModeEnabled }

    var tipKeys: [String] {
        var keys: [String] = []
        if status.level >= 0, status.level < 0.2, status.state != .charging {
            keys.append("tip_low_battery")
        }
        if !status.isLowPowerModeEnabled {
            keys.append("tip_enable_low_power_mode")
        }
        keys.append("tip_reduce_brightness")
        keys.append("tip_background_refresh")
        return keys
    }

    func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
