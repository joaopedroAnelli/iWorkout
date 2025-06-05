import Foundation

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]

    init(id: UUID = UUID(), name: String, sessions: [WorkoutSession] = []) {
        self.id = id
        self.name = name
        self.sessions = sessions
    }
}
