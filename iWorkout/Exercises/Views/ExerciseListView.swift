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
    @State private var sessionWeekday: Weekday = .monday
    @State private var showEditSession = false
    @State private var exerciseToDelete: Exercise?
    @State private var showDeleteConfirm = false
    @State private var showAddExercise = false
    @State private var newExerciseName = ""
    @State private var newExerciseSets: Int = 3
    @State private var newExerciseRest: TimeInterval = 60
    @State private var selectedExerciseId: Exercise.ID?

    var body: some View {
        ExerciseListSection(model: model,
                            selectedExerciseId: $selectedExerciseId,
                            onDelete: { exercise in
                                exerciseToDelete = exercise
                                showDeleteConfirm = true
                            },
                            onEdit: { id in
                                selectedExerciseId = id
                            })
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Edit Session") {
                    sessionName = model.session.name
                    sessionWeekday = model.session.weekday ?? .monday
                    showEditSession = true
                }
                Spacer()
                Button { showAddExercise = true } label: {
                    Label("Add Exercise", systemImage: "plus")
                }
                .bold()
            }
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseSheet(model: model,
                             name: $newExerciseName,
                             sets: $newExerciseSets,
                             rest: $newExerciseRest,
                             isPresented: $showAddExercise)
        }
        .sheet(isPresented: $showEditSession) {
            WorkoutSessionForm(titleKey: "Edit Session",
                               name: $sessionName,
                               weekday: $sessionWeekday,
                               showWeekday: model.session.weekday != nil,
                               onCancel: { showEditSession = false },
                               onSave: {
                                   model.session.name = sessionName
                                   if model.session.weekday != nil {
                                       model.session.weekday = sessionWeekday
                                   }
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

/// Displays the list of exercises with navigation links
private struct ExerciseListSection: View {
    @ObservedObject var model: ExerciseListViewModel
    @Binding var selectedExerciseId: Exercise.ID?
    var onDelete: (Exercise) -> Void
    var onEdit: (Exercise.ID) -> Void

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
                            destination: {
                                ExerciseDetailView(exercise: $exercise, model: model)
                            }
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
}

/// Sheet used to create a new exercise
private struct AddExerciseSheet: View {
    @ObservedObject var model: ExerciseListViewModel
    @Binding var name: String
    @Binding var sets: Int
    @Binding var rest: TimeInterval
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
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
                    Button { isPresented = false } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        model.addExercise(name: name, sets: sets, restDuration: rest)
                        isPresented = false
                        name = ""
                        sets = 3
                        rest = 60
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

