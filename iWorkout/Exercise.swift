//
//  Exercise.swift
//  iWorkout
//
//  Created by OpenAI on 2023.
//

import Foundation

struct Exercise: Identifiable, Codable, Equatable {
    var id = UUID()
    var nome: String
    var series: Int
    var descanso: Int // em segundos
}

extension Exercise {
    static var exemplo: [Exercise] {
        [
            Exercise(nome: "Agachamento", series: 3, descanso: 60),
            Exercise(nome: "Flexão", series: 3, descanso: 45),
            Exercise(nome: "Abdominal", series: 4, descanso: 30),
            Exercise(nome: "Levantamento Terra", series: 3, descanso: 90)
        ]
    }
}
