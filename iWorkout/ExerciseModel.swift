//
//  a.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import Foundation

class ExerciseModel: ObservableObject {
    @Published var list: [String] = ["Agachamento", "Flexão", "Abdominal", "Levantamento Terra"]
    
    init() {
            // Sempre que a lista mudar, envie pro Watch
            SharedData.shared.list = list
            SharedData.shared.enviarLista(list)
        }

        func adicionarExercicio(_ nome: String) {
            list.append(nome)
            SharedData.shared.enviarLista(list)
        }

}
