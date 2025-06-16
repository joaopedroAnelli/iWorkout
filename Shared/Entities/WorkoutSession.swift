import Foundation

struct WorkoutSession: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]
    /// Day of week for weekly transitions
    var weekday: Weekday?

    init(id: UUID = UUID(), name: String, exercises: [Exercise] = [], weekday: Weekday? = nil) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.weekday = weekday
    }

    enum CodingKeys: String, CodingKey {
        case id, name, exercises, weekday
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        exercises = try container.decodeIfPresent([Exercise].self, forKey: .exercises) ?? []
        weekday = try container.decodeIfPresent(Weekday.self, forKey: .weekday)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(exercises, forKey: .exercises)
        try container.encodeIfPresent(weekday, forKey: .weekday)
    }
}

enum Weekday: String, CaseIterable, Codable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    var id: Self { self }

    var localized: String {
        switch self {
        case .monday: return NSLocalizedString("Monday", comment: "")
        case .tuesday: return NSLocalizedString("Tuesday", comment: "")
        case .wednesday: return NSLocalizedString("Wednesday", comment: "")
        case .thursday: return NSLocalizedString("Thursday", comment: "")
        case .friday: return NSLocalizedString("Friday", comment: "")
        case .saturday: return NSLocalizedString("Saturday", comment: "")
        case .sunday: return NSLocalizedString("Sunday", comment: "")
        }
    }
}
