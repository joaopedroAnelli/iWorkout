//
//  Exercise.swift
//  iWorkout
//
//  Created by OpenAI on 2023.
//

import Foundation

struct Exercise: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var sets: Int
    var restDuration: TimeInterval
}

extension Exercise {
    static var exemplo: [Exercise] {
        [
            Exercise(name: "Agachamento", sets: 3, restDuration: 60),
            Exercise(name: "Flexão", sets: 3, restDuration: 45),
            Exercise(name: "Abdominal", sets: 4, restDuration: 30),
            Exercise(name: "Levantamento Terra", sets: 3, restDuration: 90)
        ]
    }
}
