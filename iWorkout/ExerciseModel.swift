//
//  ExerciseModel.swift
//  iWorkout
//
//  Created by OpenAI on 2023.
//

import Foundation

class ExerciseModel: ObservableObject {
    private static let storageKey = "exerciseList"

    @Published var list: [Exercise] = [] {
        didSet {
            saveList()
            sendListToWatch()
        }
    }

    init() {
        loadList()
        sendListToWatch()
    }

    func addExercise(_ name: String) {
        let newExercise = Exercise(name: name, sets: 3, restDuration: 60)
        list.append(newExercise)
    }

    func removeExercise(_ exercise: Exercise) {
        if let index = list.firstIndex(of: exercise) {
            list.remove(at: index)
        }
    }

    func sendListToWatch() {
        let names = list.map { $0.name }
        SharedData.shared.list = names
        SharedData.shared.sendList(names)
    }

    private func saveList() {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    private func loadList() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode([Exercise].self, from: data) {
            list = saved
        } else {
            list = Exercise.sampleExercises
        }
    }
}
