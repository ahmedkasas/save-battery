import Foundation
import Combine

@MainActor
final class ChargeHistoryStore: ObservableObject {
    static let shared = ChargeHistoryStore()

    @Published private(set) var sessions: [ChargeSession] = []

    private let storageKey = "com.savebattery.chargeSessions"
    private let maxStoredSessions = 100
    private var cancellables = Set<AnyCancellable>()

    private init() {
        load()
        observeBattery()
    }

    private func observeBattery() {
        BatteryMonitorService.shared.$status
            .removeDuplicates { $0.state == $1.state }
            .sink { [weak self] status in
                self?.handle(status)
            }
            .store(in: &cancellables)
    }

    private func handle(_ status: BatteryStatus) {
        switch status.state {
        case .charging, .full:
            if sessions.last?.isOngoing != true {
                sessions.append(ChargeSession(startDate: Date(), startLevel: status.level))
                trim()
                save()
            }
        case .unplugged, .unknown:
            if var last = sessions.last, last.isOngoing {
                last.endDate = Date()
                last.endLevel = status.level
                sessions[sessions.count - 1] = last
                save()
            }
        }
    }

    private func trim() {
        if sessions.count > maxStoredSessions {
            sessions.removeFirst(sessions.count - maxStoredSessions)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ChargeSession].self, from: data) else { return }
        sessions = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
