import Foundation

enum Weekday: String, CaseIterable, Codable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: String { rawValue }
}

struct WorkoutSession: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var repetitions: Int
    var weekday: Weekday?
    var exercises: [Exercise]

    init(id: UUID = UUID(),
         name: String,
         repetitions: Int = 1,
         weekday: Weekday? = nil,
         exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.repetitions = repetitions
        self.weekday = weekday
        self.exercises = exercises
    }
}
