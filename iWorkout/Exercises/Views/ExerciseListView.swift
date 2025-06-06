//
//  ExerciseListView.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ExerciseListView: View {
    @StateObject var model: ExerciseListViewModel
    @State private var sessionName = ""
    @State private var exerciseToDelete: Exercise?
    @State private var showDeleteConfirm = false
    @State private var showAddExercise = false
    @State private var newExerciseName = ""
    @State private var newExerciseSets: Int = 3
    @State private var newExerciseRest: TimeInterval = 60

    
    // Função auxiliar para formatar TimeInterval em "HH:mm:ss" ou "mm:ss"
    private func formattedTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 60)
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var body: some View {
        List {
            Section("Name") {
                TextField("Name", text: $sessionName, onEditingChanged: { editing in
                    if !editing {
                        model.session.name = sessionName
                    }
                })
            }
            Section("Exercises") {
                if model.list.isEmpty {
                    Text("You haven't added exercises yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach($model.list) { $exercise in
                        ExerciseRow(exercise: $exercise, model: model) {
                            exerciseToDelete = exercise
                            showDeleteConfirm = true
                        }
                    }
                }
            }
        }
        .toolbar {
            Button { showAddExercise = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showAddExercise) {
            NavigationView {
                Form {
                    Section("Name") { TextField("Name", text: $newExerciseName) }
                    Section("Sets") {
                        Stepper(value: $newExerciseSets, in: 1...10) {
                            Text("\(newExerciseSets) sets")
                        }
                    }
                    Section("Rest") {
                        CountdownTimerPicker(duration: $newExerciseRest)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .padding(.horizontal)
                    }
                }
                .navigationTitle("New Exercise")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showAddExercise = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            model.addExercise(name: newExerciseName, sets: newExerciseSets, restDuration: newExerciseRest)
                            showAddExercise = false
                            newExerciseName = ""
                            newExerciseSets = 3
                            newExerciseRest = 60
                        }
                        .disabled(newExerciseName.isEmpty)
                    }
                }
            }
        }
        .navigationTitle(sessionName)
        .onAppear { sessionName = model.session.name }
        .onDisappear { model.session.name = sessionName }
        .alert("Delete exercise?", isPresented: $showDeleteConfirm, presenting: exerciseToDelete) { exercise in
            Button("Delete", role: .destructive) {
                model.removeExercise(exercise)
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView(model: ExerciseListViewModel())
    }
}

// A separate view for a single exercise row
struct ExerciseRow: View {
    @Binding var exercise: Exercise
    var model: ExerciseListViewModel
    var onDelete: () -> Void

    var body: some View {
        NavigationLink(destination: ExerciseDetailView(exercise: $exercise, model: model)) {
            Text(exercise.name)
        }
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
