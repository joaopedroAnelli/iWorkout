//
//  a.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import Foundation

// Key used to persist the exercises on the device
private let exercisesKey = "savedExercises"

class ExerciseModel: ObservableObject {
    // Published list of exercises. Whenever it's updated, we persist and
    // send the new list to the watch.
    @Published var list: [String] = [] {
        didSet {
            saveExercises()
            SharedData.shared.list = list
            SharedData.shared.enviarLista(list)
        }
    }

    init() {
        loadExercises()
    }

    /// Adds a new exercise to the list
    func adicionarExercicio(_ nome: String) {
        list.append(nome)
    }

    /// Loads the exercises from UserDefaults or populates with a default list
    private func loadExercises() {
        if let data = UserDefaults.standard.data(forKey: exercisesKey),
           let saved = try? JSONDecoder().decode([String].self, from: data) {
            list = saved
        } else {
            list = ["Agachamento", "Flexão", "Abdominal", "Levantamento Terra"]
        }
    }

    /// Saves the current exercises list to UserDefaults
    private func saveExercises() {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: exercisesKey)
        }
    }
}
