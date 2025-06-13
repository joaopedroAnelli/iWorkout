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

    var body: some View {
        List {
            ExercisesSection(exercises: $model.list,
                             selectedExerciseId: $selectedExerciseId,
                             model: model,
                             onDelete: { exercise in
                                exerciseToDelete = exercise
                                showDeleteConfirm = true
                             },
                             onEdit: { id in
                                selectedExerciseId = id
                             })
        }
        .toolbar { toolbarContent }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseSheet(name: $newExerciseName,
                             sets: $newExerciseSets,
                             rest: $newExerciseRest,
                             onCancel: { showAddExercise = false },
                             onAdd: {
                                model.addExercise(name: newExerciseName,
                                                  sets: newExerciseSets,
                                                  restDuration: newExerciseRest)
                                showAddExercise = false
                                newExerciseName = ""
                                newExerciseSets = 3
                                newExerciseRest = 60
                             })
        }
        .sheet(isPresented: $showEditSession) {
            EditSessionSheet(name: $sessionName,
                             onCancel: { showEditSession = false },
                             onSave: {
                                model.session.name = sessionName
                                showEditSession = false
                             })
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
            Button(role: .destructive) {
                model.removeExercise(exercise)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(Color("AlertCoral"))
            Button(role: .cancel) { } label: {
                Label("Cancel", systemImage: "xmark")
            }
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

private struct ExercisesSection: View {
    @Binding var exercises: [Exercise]
    @Binding var selectedExerciseId: Exercise.ID?
    var model: ExerciseListViewModel
    var onDelete: (Exercise) -> Void
    var onEdit: (Exercise.ID) -> Void

    var body: some View {
        Section {
            if exercises.isEmpty {
                Text("You haven't added exercises yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach($exercises) { $exercise in
                    NavigationLink(
                        tag: exercise.id,
                        selection: $selectedExerciseId,
                        destination: { ExerciseDetailView(exercise: $exercise, model: model) }
                    ) {
                        ExerciseRow(exercise: $exercise) {
                            onDelete(exercise)
                        } onEdit: {
                            onEdit(exercise.id)
                        }
                    }
                }
            }
        }
    }
}

private struct AddExerciseSheet: View {
    @Binding var name: String
    @Binding var sets: Int
    @Binding var rest: TimeInterval
    var onCancel: () -> Void
    var onAdd: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section("Name") { TextField("Name", text: $name) }
                Section("Sets") {
                    Stepper(value: $sets, in: 1...10) {
                        Text("\(sets) sets")
                    }
                }
                Section("Rest") {
                    CountdownTimerPicker(duration: $rest)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .padding(.horizontal)
                }
            }
            .navigationTitle("New Exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: onCancel) {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: onAdd) {
                        Label("Add", systemImage: "plus")
                    }
                    .disabled(name.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

private struct EditSessionSheet: View {
    @Binding var name: String
    var onCancel: () -> Void
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form { TextField("Session name", text: $name) }
                .navigationTitle("Edit Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: onCancel) {
                            Label("Cancel", systemImage: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: onSave) {
                            Label("Save", systemImage: "checkmark")
                        }
                        .disabled(name.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
        }
    }
}

@ToolbarContentBuilder
private var toolbarContent: some ToolbarContent {
    ToolbarItemGroup(placement: .bottomBar) {
        Button {
            sessionName = model.session.name
            showEditSession = true
        } label: {
            Label("Edit Session", systemImage: "pencil")
        }
        Spacer()
        Button { showAddExercise = true } label: {
            Label("Add Exercise", systemImage: "plus")
        }
        .bold()
    }
}
