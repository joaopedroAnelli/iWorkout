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
                        .swipeActions {                            Button(role: .destructive) {
                                viewModel.removeSession(session)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
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
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showAddSession = true }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    editedStyleName = viewModel.style.name
                    showEditStyle = true
                }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showAddSession) {
            NavigationView {
                Form {
                    TextField("Session name", text: $newSessionName)
                }
                .navigationTitle("New Session")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showAddSession = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            viewModel.addSession(newSessionName)
                            showAddSession = false
                            newSessionName = ""
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
