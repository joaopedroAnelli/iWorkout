import Foundation

struct WorkoutSession: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var exercises: [Exercise]

    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}
