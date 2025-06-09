import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel
    @State private var showAddSession = false
    @State private var newSessionName = ""
    @State private var showEditStyle = false
    @State private var editedStyleName = ""
    @State private var editedStyleNavigation = SessionNavigation.weekday
    @State private var editedStyleActive = true
    @State private var editedActiveUntil = Date()
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
                    editedStyleNavigation = viewModel.style.navigation
                    editedStyleActive = viewModel.style.isActive
                    editedActiveUntil = viewModel.style.activeUntil ?? Date()
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
                WorkoutStyleForm(name: $editedStyleName,
                                 navigation: $editedStyleNavigation,
                                 isActive: $editedStyleActive,
                                 activeUntil: $editedActiveUntil)
                .navigationTitle("Edit Style")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showEditStyle = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            viewModel.style.name = editedStyleName
                            viewModel.style.navigation = editedStyleNavigation
                            viewModel.style.isActive = editedStyleActive
                            viewModel.style.activeUntil = editedStyleActive ? editedActiveUntil : nil
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
