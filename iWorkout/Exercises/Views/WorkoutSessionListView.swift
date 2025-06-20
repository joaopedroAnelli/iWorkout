import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel
    @State private var showAddSession = false
    @State private var newSessionName = ""
    @State private var showEditStyle = false
    @State private var editedStyleName = ""
    @State private var editedIsActive = false
    @State private var editedActiveUntil = Date()
    @State private var editedTransition: DivisionTransition = .sequential
    @State private var editingSession: WorkoutSession?
    @State private var editedSessionName = ""
    @State private var newSessionWeekday: Weekday = .monday
    @State private var editedSessionWeekday: Weekday = .monday

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
                            ExerciseListView(model: ExerciseListViewModel(session: session,
                                                                       transition: viewModel.style.transition) { updated in
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
                                editedSessionWeekday = session.weekday ?? .monday
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
        .toolbar {
            ToolbarItemGroup {
                Button("Edit Workout") {
                    editedStyleName = viewModel.style.name
                    editedIsActive = viewModel.style.isActive
                    editedActiveUntil = viewModel.style.activeUntil ?? Date()
                    editedTransition = viewModel.style.transition
                    showEditStyle = true
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()

                Button {
                    showAddSession = true
                } label: {
                    Label(NSLocalizedString("Add Session", comment: ""), systemImage: "plus")
                }
                .fontWeight(.bold)
            }
        }
        .sheet(isPresented: $showAddSession) {
            NavigationStack {
                Form {
                    TextField("Session name", text: $newSessionName)
                    if viewModel.style.transition == .weekly {
                        Picker("Weekday", selection: $newSessionWeekday) {
                            ForEach(Weekday.allCases) { Text($0.localized).tag($0) }
                        }
                    }
                }
                .navigationTitle("New Session")
                .onAppear {
                    newSessionName = ""
                    newSessionWeekday = .monday
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button { showAddSession = false } label: {
                            Label("Cancel", systemImage: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.addSession(newSessionName,
                                                weekday: viewModel.style.transition == .weekly ? newSessionWeekday : nil)
                            showAddSession = false
                            newSessionName = ""
                            newSessionWeekday = .monday
                        } label: {
                            Label("Add", systemImage: "checkmark")
                        }
                        .disabled(newSessionName.isEmpty)
                    }
                }
            }
        }
        .sheet(item: $editingSession) { session in
            WorkoutSessionForm(titleKey: "Edit Session",
                               name: $editedSessionName,
                               weekday: $editedSessionWeekday,
                               showWeekday: viewModel.style.transition == .weekly,
                               onCancel: { editingSession = nil },
                               onSave: {
                                   var updated = session
                                   updated.name = editedSessionName
                                   updated.weekday = viewModel.style.transition == .weekly ? editedSessionWeekday : nil
                                   viewModel.updateSession(updated)
                                   editingSession = nil
                               })
            .onAppear {
                editedSessionName = session.name
                editedSessionWeekday = session.weekday ?? .monday
            }
        }
        .sheet(isPresented: $showEditStyle) {
            NavigationStack {
                WorkoutStyleForm(name: $editedStyleName,
                                 transition: $editedTransition,
                                 isActive: $editedIsActive,
                                 activeUntil: $editedActiveUntil)
                .navigationTitle("Edit Style")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button { showEditStyle = false } label: {
                            Label("Cancel", systemImage: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.style.name = editedStyleName
                            viewModel.style.transition = editedTransition
                            viewModel.style.isActive = editedIsActive
                            viewModel.style.activeUntil = editedIsActive ? editedActiveUntil : nil
                            showEditStyle = false
                        } label: {
                            Label("Save", systemImage: "checkmark")
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
