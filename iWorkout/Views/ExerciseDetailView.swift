//
//  DetalheExercicioView.swift
//  iWorkout
//
//  Created by João Anelli on 6/4/25.
//

import SwiftUI


struct ExerciseDetailView: View {
    @Binding var exercise: Exercise
    @ObservedObject var model: ExerciseModel
    @State private var durationInSeconds: TimeInterval = 60 * 5

    var body: some View {
        Form {
            Section("Nome") {
                TextField("Nome", text: $exercise.name)
                    .autocorrectionDisabled(false)
            }
            Section("Séries") {
                Stepper(value: $exercise.sets, in: 1...10) {
                    Text("\(exercise.sets) séries")
                }
            }
            Section("Descanso") {
                CountdownTimerPicker(duration: $durationInSeconds)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .padding(.horizontal)
            }
        }
        .navigationTitle("Editar Exercício")
        .onAppear {
            // Initialize the picker with the current value from the model
            durationInSeconds = exercise.restDuration
        }
        .onDisappear {
            // Persist any changes back to the underlying Exercise
            exercise.restDuration = durationInSeconds
            model.sendListToWatch()
        }
    }
}


struct ExerciseDetailView_Preview: PreviewProvider {
    @State static private var exercise: Exercise = Exercise(name: "Agachamento", sets: 3, restDuration: 60)
    
    static private var model: ExerciseModel = ExerciseModel()
    
    static var previews: some View {
        ExerciseDetailView(exercise: $exercise, model: model)
    }
}

