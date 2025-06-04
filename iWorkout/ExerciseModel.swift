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
            enviarListaParaWatch()
        }
    }

    init() {
        loadList()
        enviarListaParaWatch()
    }

    func adicionarExercicio(_ nome: String) {
        let novo = Exercise(name: nome, sets: 3, restDuration: 60)
        list.append(novo)
    }

    func removeExercise(_ exercise: Exercise) {
        if let index = list.firstIndex(of: exercise) {
            list.remove(at: index)
        }
    }

    func enviarListaParaWatch() {
        let nomes = list.map { $0.name }
        SharedData.shared.list = nomes
        SharedData.shared.enviarLista(nomes)
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
            list = Exercise.exemplo
        }
    }
}
