//
//  DetalheExercicioView.swift
//  iWorkout
//
//  Created by João Anelli on 6/4/25.
//

import SwiftUI


struct ExerciseDetailView: View {
    @Binding var exercise: Exercise
    @ObservedObject var model: ExerciseListViewModel

    // Local state so edits do not immediately mutate the data model
    @State private var editedName: String = ""
    @State private var editedSets: Int = 3
    @State private var durationInSeconds: TimeInterval = 60

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $editedName)
                    .autocorrectionDisabled(false)
            }
            Section("Sets") {
                Stepper(value: $editedSets, in: 1...10) {
                    Text("\(editedSets) sets")
                }
            }
            Section("Rest") {
                CountdownTimerPicker(duration: $durationInSeconds)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Edit Exercise")
        .onAppear {
            // Load existing values into local state
            editedName = exercise.name
            editedSets = exercise.sets
            durationInSeconds = exercise.restDuration
        }
        .onDisappear {
            // Persist changes back to the bound exercise and update watch
            exercise.name = editedName
            exercise.sets = editedSets
            exercise.restDuration = durationInSeconds
            model.sendListToWatch()
        }
    }
}


struct ExerciseDetailView_Preview: PreviewProvider {
    @State static private var exercise: Exercise = Exercise(name: "Agachamento", sets: 3, restDuration: 60)
    
    static private var model: ExerciseListViewModel = ExerciseListViewModel()
    
    static var previews: some View {
        ExerciseDetailView(exercise: $exercise, model: model)
    }
}

