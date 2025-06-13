import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel
    @State private var showAddSession = false
    @State private var newSessionName = ""
    @State private var showEditStyle = false
    @State private var editedStyleName = ""
    @State private var editingSession: WorkoutSession?
    @State private var editedSessionName = ""

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
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    editedStyleName = viewModel.style.name
                    showEditStyle = true
                } label: {
                    Label(NSLocalizedString("Edit Workout", comment: ""), systemImage: "pencil")
                }

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
                }
                .navigationTitle("New Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button { showAddSession = false } label: {
                            Label("Cancel", systemImage: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.addSession(newSessionName)
                            showAddSession = false
                            newSessionName = ""
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .disabled(newSessionName.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .sheet(item: $editingSession) { session in
            NavigationStack {
                Form {
                    TextField("Session name", text: $editedSessionName)
                }
                .navigationTitle("Edit Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button { editingSession = nil } label: {
                            Label("Cancel", systemImage: "xmark")
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            var updated = session
                            updated.name = editedSessionName
                            viewModel.updateSession(updated)
                            editingSession = nil
                        } label: {
                            Label("Save", systemImage: "checkmark")
                        }
                        .disabled(editedSessionName.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditStyle) {
            NavigationStack {
                Form {
                    TextField("Style name", text: $editedStyleName)
                }
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
                            showEditStyle = false
                        } label: {
                            Label("Save", systemImage: "checkmark")
                        }
                        .disabled(editedStyleName.isEmpty)
                        .buttonStyle(.borderedProminent)
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
