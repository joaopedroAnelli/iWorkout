import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(model.styles) { style in
                    NavigationLink(style.name) {
                        WorkoutSessionListView(viewModel: WorkoutSessionViewModel(style: style) { updated in
                            model.updateStyle(updated)
                        })
                    }
                }
                .onDelete { indexSet in
                    model.styles.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                Button(action: { showAddStyle = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddStyle) {
                NavigationView {
                    Form {
                        TextField("Style name", text: $newStyleName)
                    }
                    .navigationTitle("New Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddStyle = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                model.addStyle(newStyleName)
                                showAddStyle = false
                                newStyleName = ""
                            }
                            .disabled(newStyleName.isEmpty)
                        }
                    }
                }
            }
        }
    }
}

struct WorkoutStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStyleListView()
    }
}
