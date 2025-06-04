//
//  ContentView.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    // Lista exemplo de exercícios
    @StateObject var model = ExerciseModel()

    var body: some View {
        NavigationView {
            List {
                ForEach($model.list) { $exercise in
                    NavigationLink(destination: DetalheExercicioView(exercise: $exercise, model: model)) {
                        Text(exercise.nome)
                    }
                }
            }
            .toolbar {
                Button {
                    model.adicionarExercicio("Novo Ex. \(model.list.count + 1)")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Meus Treinos")
        }
    }
}

struct DetalheExercicioView: View {
    @Binding var exercise: Exercise
    @ObservedObject var model: ExerciseModel

    var body: some View {
        Form {
            Section("Nome") {
                TextField("Nome", text: $exercise.nome)
                    .autocorrectionDisabled(false)
            }
            Section("Séries") {
                Stepper(value: $exercise.series, in: 1...10) {
                    Text("\(exercise.series) séries")
                }
            }
            Section("Descanso") {
                Stepper(value: $exercise.descanso, in: 15...300, step: 15) {
                    Text("\(exercise.descanso)s entre séries")
                }
            }
        }
        .navigationTitle("Editar Exercício")
        .onDisappear {
            model.enviarListaParaWatch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
