import Foundation

struct WorkoutStyle: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]
    /// Defines how the style's sessions advance
    var transition: DivisionTransition
    /// Indicates if the style is currently active
    var isActive: Bool
    /// Time when the style should automatically deactivate
    var activeUntil: Date?
    /// Identifier of the last completed session when transitioning sequentially
    var lastCompletedSessionId: UUID?

    init(id: UUID = UUID(),
         name: String,
         sessions: [WorkoutSession] = [],
         transition: DivisionTransition = .sequential,
         isActive: Bool = false,
         activeUntil: Date? = nil,
         lastCompletedSessionId: UUID? = nil) {
        self.id = id
        self.name = name
        self.sessions = sessions
        self.transition = transition
        self.isActive = isActive
        self.activeUntil = activeUntil
        self.lastCompletedSessionId = lastCompletedSessionId
    }

    enum CodingKeys: String, CodingKey {
        case id, name, sessions, transition, isActive, activeUntil, lastCompletedSessionId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        sessions = try container.decodeIfPresent([WorkoutSession].self, forKey: .sessions) ?? []
        transition = try container.decodeIfPresent(DivisionTransition.self, forKey: .transition) ?? .sequential
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        activeUntil = try container.decodeIfPresent(Date.self, forKey: .activeUntil)
        lastCompletedSessionId = try container.decodeIfPresent(UUID.self, forKey: .lastCompletedSessionId)
    }

}
