import Foundation

enum SessionNavigation: String, Codable, CaseIterable, Identifiable {
    case weekday
    case sequential

    var id: String { rawValue }
}

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]
    var navigation: SessionNavigation
    var isActive: Bool
    var activeUntil: Date?

    init(id: UUID = UUID(),
         name: String,
         sessions: [WorkoutSession] = [],
         navigation: SessionNavigation = .weekday,
         isActive: Bool = true,
         activeUntil: Date? = nil) {
        self.id = id
        self.name = name
        self.sessions = sessions
        self.navigation = navigation
        self.isActive = isActive
        self.activeUntil = activeUntil
    }
}
