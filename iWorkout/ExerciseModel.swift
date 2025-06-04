//
//  ExerciseModel.swift
//  iWorkout
//
//  Created by OpenAI on 2023.
//

import Foundation

class ExerciseModel: ObservableObject {
    @Published var list: [Exercise] = Exercise.exemplo {
        didSet {
            enviarListaParaWatch()
        }
    }

    init() {
        enviarListaParaWatch()
    }

    func adicionarExercicio(_ nome: String) {
        let novo = Exercise(nome: nome, series: 3, descanso: 60)
        list.append(novo)
    }

    func enviarListaParaWatch() {
        let nomes = list.map { $0.nome }
        SharedData.shared.list = nomes
        SharedData.shared.enviarLista(nomes)
    }
}
