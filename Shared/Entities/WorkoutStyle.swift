import Foundation

enum SessionBy: String, CaseIterable, Codable {
    case sequence, weekday
}

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessionBy: SessionBy
    var sessions: [WorkoutSession]

    init(id: UUID = UUID(),
         name: String,
         sessionBy: SessionBy = .sequence,
         sessions: [WorkoutSession] = []) {
        self.id = id
        self.name = name
        self.sessionBy = sessionBy
        self.sessions = sessions
    }
}
