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
    @State private var showEditSession = false
    @State private var exerciseToDelete: Exercise?
    @State private var showDeleteConfirm = false
    @State private var showAddExercise = false
    @State private var newExerciseName = ""
    @State private var newExerciseSets: Int = 3
    @State private var newExerciseRest: TimeInterval = 60
    @State private var selectedExerciseId: Exercise.ID?

    
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
            Section {
                if model.list.isEmpty {
                    Text("You haven't added exercises yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach($model.list) { $exercise in
                        NavigationLink(
                            tag: exercise.id,
                            selection: $selectedExerciseId,
                            destination: { ExerciseDetailView(exercise: $exercise, model: model) }
                        ) {
                            ExerciseRow(exercise: $exercise) {
                                exerciseToDelete = exercise
                                showDeleteConfirm = true
                            } onEdit: {
                                selectedExerciseId = exercise.id
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Exercise") { showAddExercise = true }
                    .bold()
                Spacer()
                Button("Edit Session") {
                    sessionName = model.session.name
                    showEditSession = true
                }
            }
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
        .sheet(isPresented: $showEditSession) {
            NavigationView {
                Form {
                    TextField("Session name", text: $sessionName)
                }
                .navigationTitle("Edit Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showEditSession = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            model.session.name = sessionName
                            showEditSession = false
                        }
                        .disabled(sessionName.isEmpty)
                    }
                }
            }
        }
        .navigationTitle(model.session.name)
        .onChange(of: selectedExerciseId) { newValue in
            if newValue == nil { model.commitIfNeeded() }
        }
        .onDisappear {
            if selectedExerciseId == nil && !showAddExercise && !showEditSession {
                model.commitIfNeeded()
            }
        }
        .alert("Delete exercise?", isPresented: $showDeleteConfirm, presenting: exerciseToDelete) { exercise in
            Button("Delete", role: .destructive) {
                model.removeExercise(exercise)
            }
            .tint(Color("AlertCoral"))
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
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        Text(exercise.name)
            .swipeActions {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(Color("AlertCoral"))
                Button { onEdit() } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.yellow)
            }
    }
}
