import Foundation

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]
    /// Indicates if the style is currently active
    var isActive: Bool
    /// Time when the style should automatically deactivate
    var activeUntil: Date?

    init(id: UUID = UUID(),
         name: String,
         sessions: [WorkoutSession] = [],
         isActive: Bool = false,
         activeUntil: Date? = nil) {
        self.id = id
        self.name = name
        self.sessions = sessions
        self.isActive = isActive
        self.activeUntil = activeUntil
    }

    enum CodingKeys: String, CodingKey {
        case id, name, sessions, isActive, activeUntil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        sessions = try container.decodeIfPresent([WorkoutSession].self, forKey: .sessions) ?? []
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        activeUntil = try container.decodeIfPresent(Date.self, forKey: .activeUntil)
    }
}
