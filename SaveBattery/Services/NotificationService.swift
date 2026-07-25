import Foundation
import UserNotifications
import Combine

@MainActor
final class NotificationService: ObservableObject {
    static let shared = NotificationService()

    static let chargeLimitEnabledKey = "com.savebattery.chargeLimitReminderEnabled"
    static let chargeLimitPercentKey = "com.savebattery.chargeLimitPercent"
    static let defaultChargeLimitPercent = 80

    private let center = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    private var hasNotifiedForCurrentSession = false

    private init() {
        observeBattery()
    }

    func requestAuthorizationIfNeeded() {
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private var isReminderEnabled: Bool {
        defaults.object(forKey: Self.chargeLimitEnabledKey) as? Bool ?? true
    }

    private var chargeLimitPercent: Int {
        defaults.object(forKey: Self.chargeLimitPercentKey) as? Int ?? Self.defaultChargeLimitPercent
    }

    private func observeBattery() {
        BatteryMonitorService.shared.$status
            .sink { [weak self] status in
                self?.evaluate(status)
            }
            .store(in: &cancellables)
    }

    private func evaluate(_ status: BatteryStatus) {
        guard isReminderEnabled else { return }

        switch status.state {
        case .charging:
            let threshold = chargeLimitPercent
            let currentPercent = Int((status.level * 100).rounded())
            if !hasNotifiedForCurrentSession, status.level >= 0, currentPercent >= threshold {
                hasNotifiedForCurrentSession = true
                notifyChargeLimitReached(threshold: threshold)
            }
        case .full, .unplugged, .unknown:
            hasNotifiedForCurrentSession = false
        }
    }

    private func notifyChargeLimitReached(threshold: Int) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification_charge_limit_title", comment: "")
        content.body = String(format: NSLocalizedString("notification_charge_limit_body", comment: ""), threshold)
        content.sound = .default

        let request = UNNotificationRequest(identifier: "charge-limit-reached", content: content, trigger: nil)
        center.add(request)
    }
}
