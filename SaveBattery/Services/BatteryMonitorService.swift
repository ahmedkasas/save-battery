import Foundation
import UIKit
import Combine

@MainActor
final class BatteryMonitorService: ObservableObject {
    static let shared = BatteryMonitorService()

    @Published private(set) var status: BatteryStatus

    private var cancellables = Set<AnyCancellable>()

    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        status = BatteryStatus(
            level: UIDevice.current.batteryLevel,
            state: Self.mapState(UIDevice.current.batteryState),
            isLowPowerModeEnabled: ProcessInfo.processInfo.isLowPowerModeEnabled
        )
        observe()
    }

    private func observe() {
        NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification))
            .merge(with: NotificationCenter.default.publisher(for: .NSProcessInfoPowerStateDidChange))
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }

    func refresh() {
        status = BatteryStatus(
            level: UIDevice.current.batteryLevel,
            state: Self.mapState(UIDevice.current.batteryState),
            isLowPowerModeEnabled: ProcessInfo.processInfo.isLowPowerModeEnabled
        )
    }

    private static func mapState(_ state: UIDevice.BatteryState) -> BatteryStatus.State {
        switch state {
        case .unknown: return .unknown
        case .unplugged: return .unplugged
        case .charging: return .charging
        case .full: return .full
        @unknown default: return .unknown
        }
    }
}
