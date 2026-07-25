import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var chargeLimitReminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(chargeLimitReminderEnabled, forKey: NotificationService.chargeLimitEnabledKey)
        }
    }

    @Published var chargeLimitPercent: Double {
        didSet {
            UserDefaults.standard.set(Int(chargeLimitPercent), forKey: NotificationService.chargeLimitPercentKey)
        }
    }

    init() {
        let defaults = UserDefaults.standard
        self.chargeLimitReminderEnabled = defaults.object(forKey: NotificationService.chargeLimitEnabledKey) as? Bool ?? true
        let storedPercent = defaults.object(forKey: NotificationService.chargeLimitPercentKey) as? Int
        self.chargeLimitPercent = Double(storedPercent ?? NotificationService.defaultChargeLimitPercent)
    }

    func requestNotificationPermission() {
        NotificationService.shared.requestAuthorizationIfNeeded()
    }
}
