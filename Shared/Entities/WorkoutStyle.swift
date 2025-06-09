import Foundation

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]
    var isActive: Bool
    var activeUntil: Date?

    init(id: UUID = UUID(),
         name: String,
         sessions: [WorkoutSession] = [],
         isActive: Bool = true,
         activeUntil: Date? = nil) {
        self.id = id
        self.name = name
        self.sessions = sessions
        self.isActive = isActive
        self.activeUntil = activeUntil
    }
}
