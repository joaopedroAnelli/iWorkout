import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel
    @State private var showAddSession = false
    @State private var newSessionName = ""
    @State private var newRepetitions: Int = 1
    @State private var newWeekday: Weekday = .monday
    @State private var showEditStyle = false
    @State private var editedStyleName = ""
    @State private var editingSession: WorkoutSession?
    @State private var editedSessionName = ""
    @State private var editedRepetitions: Int = 1
    @State private var editedWeekday: Weekday = .monday

    var body: some View {
        List {
            Section {
                if viewModel.sessions.isEmpty {
                    Text("You haven't added sessions yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.sessions) { session in
                        NavigationLink(session.name) {
                            ExerciseListView(model: ExerciseListViewModel(session: session) { updated in
                                viewModel.updateSession(updated)
                            })
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.removeSession(session)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(Color("AlertCoral"))
                            Button {
                                editingSession = session
                                editedSessionName = session.name
                                editedRepetitions = session.repetitions
                                editedWeekday = session.weekday ?? .monday
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.yellow)

                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.style.name)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(NSLocalizedString("Add Session", comment: "")) {
                    showAddSession = true
                }
                .fontWeight(.bold)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)

                Spacer()

                Button(NSLocalizedString("Edit Workout", comment: "")) {
                    editedStyleName = viewModel.style.name
                    showEditStyle = true
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showAddSession) {
            NavigationView {
                Form {
                    TextField("Session name", text: $newSessionName)
                    Stepper(value: $newRepetitions, in: 1...50) {
                        Text("\(newRepetitions) " + NSLocalizedString("Repetitions", comment: ""))
                    }
                    if viewModel.style.sessionBy == .weekday {
                        Picker("Weekday", selection: $newWeekday) {
                            ForEach(Weekday.allCases) { day in
                                Text(NSLocalizedString(day.rawValue.capitalized, comment: "")).tag(day)
                            }
                        }
                    }
                }
                .navigationTitle("New Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showAddSession = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            let weekday = viewModel.style.sessionBy == .weekday ? newWeekday : nil
                            viewModel.addSession(newSessionName, repetitions: newRepetitions, weekday: weekday)
                            showAddSession = false
                            newSessionName = ""
                            newRepetitions = 1
                        }
                        .disabled(newSessionName.isEmpty)
                    }
                }
            }
        }
        .sheet(item: $editingSession) { session in
            NavigationView {
                Form {
                    TextField("Session name", text: $editedSessionName)
                    Stepper(value: $editedRepetitions, in: 1...50) {
                        Text("\(editedRepetitions) " + NSLocalizedString("Repetitions", comment: ""))
                    }
                    if viewModel.style.sessionBy == .weekday {
                        Picker("Weekday", selection: $editedWeekday) {
                            ForEach(Weekday.allCases) { day in
                                Text(NSLocalizedString(day.rawValue.capitalized, comment: "")).tag(day)
                            }
                        }
                    }
                }
                .navigationTitle("Edit Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { editingSession = nil }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            var updated = session
                            updated.name = editedSessionName
                            updated.repetitions = editedRepetitions
                            updated.weekday = viewModel.style.sessionBy == .weekday ? editedWeekday : nil
                            viewModel.updateSession(updated)
                            editingSession = nil
                        }
                        .disabled(editedSessionName.isEmpty)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditStyle) {
            NavigationView {
                Form {
                    TextField("Style name", text: $editedStyleName)
                }
                .navigationTitle("Edit Style")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showEditStyle = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            viewModel.style.name = editedStyleName
                            showEditStyle = false
                        }
                        .disabled(editedStyleName.isEmpty)
                    }
                }
            }
        }
    }
}

struct WorkoutSessionListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionListView(viewModel: WorkoutSessionViewModel(style: WorkoutStyle(name: "Style")))
    }
}
