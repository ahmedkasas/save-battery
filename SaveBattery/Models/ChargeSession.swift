import Foundation

struct ChargeSession: Identifiable, Codable, Equatable {
    let id: UUID
    let startDate: Date
    var endDate: Date?
    let startLevel: Float
    var endLevel: Float?

    init(id: UUID = UUID(), startDate: Date, endDate: Date? = nil, startLevel: Float, endLevel: Float? = nil) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.startLevel = startLevel
        self.endLevel = endLevel
    }

    var isOngoing: Bool { endDate == nil }

    var duration: TimeInterval? {
        guard let endDate else { return nil }
        return endDate.timeIntervalSince(startDate)
    }

    var levelGained: Float? {
        guard let endLevel else { return nil }
        return max(0, endLevel - startLevel)
    }
}
