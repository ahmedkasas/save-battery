import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var sessions: [ChargeSession] = []

    private var cancellables = Set<AnyCancellable>()

    init(store: ChargeHistoryStore = .shared) {
        self.sessions = store.sessions.reversed()
        store.$sessions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.sessions = $0.reversed() }
            .store(in: &cancellables)
    }

    func durationText(for session: ChargeSession) -> String {
        guard let duration = session.duration else {
            return NSLocalizedString("history_ongoing", comment: "")
        }
        let minutes = Int(duration / 60)
        if minutes < 60 {
            return String(format: NSLocalizedString("history_minutes_format", comment: ""), minutes)
        }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: NSLocalizedString("history_hours_minutes_format", comment: ""), hours, remainingMinutes)
    }

    func levelText(for session: ChargeSession) -> String {
        let start = Int((session.startLevel * 100).rounded())
        guard let endLevel = session.endLevel else {
            return "\(start)% → …"
        }
        let end = Int((endLevel * 100).rounded())
        return "\(start)% → \(end)%"
    }
}
