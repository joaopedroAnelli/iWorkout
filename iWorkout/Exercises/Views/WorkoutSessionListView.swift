import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel
    @State private var showAddSession = false
    @State private var newSessionName = ""

    var body: some View {
        List {
            Section {
                TextField("Style name", text: $viewModel.style.name)
            }
            Section {
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
                    }
                }
            }
        }
        .navigationTitle(viewModel.style.name)
        .toolbar {
            Button(action: { showAddSession = true }) {
                Image(systemName: "plus")
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
    }
}

struct WorkoutSessionListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionListView(viewModel: WorkoutSessionViewModel(style: WorkoutStyle(name: "Style")))
    }
}
