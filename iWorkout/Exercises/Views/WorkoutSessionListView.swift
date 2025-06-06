import SwiftUI

/// Displays the sessions of a given workout style
struct WorkoutSessionListView: View {
    @StateObject var viewModel: WorkoutSessionViewModel

    var body: some View {
        List {
            Section("Name") {
                TextField("Style name", text: $viewModel.style.name)
            }
            Section ("Sessions") {
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
            Button(action: addSession) {
                Image(systemName: "plus")
            }
        }
    }

    private func addSession() {
        let title = String(format: NSLocalizedString("Session %d", comment: "Default session name"), viewModel.sessions.count + 1)
        viewModel.addSession(title)
    }
}

struct WorkoutSessionListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionListView(viewModel: WorkoutSessionViewModel(style: WorkoutStyle(name: "Style")))
    }
}
