import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""
    @State private var editingStyle: WorkoutStyle?
    @State private var editedStyleName = ""

    var body: some View {
        NavigationStack {
            List {
                if model.styles.isEmpty {
                    Text("You haven't added workouts yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(model.styles) { style in
                        NavigationLink(style.name) {
                            WorkoutSessionListView(viewModel: WorkoutSessionViewModel(style: style) { updated in
                                model.updateStyle(updated)
                            })
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let idx = model.styles.firstIndex(of: style) {
                                    model.styles.remove(at: idx)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(Color("AlertCoral"))
                            Button {
                                editingStyle = style
                                editedStyleName = style.name
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.yellow)
                        }
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button { showAddStyle = true } label: {
                        Label("Add Workout", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddStyle) {
                NavigationStack {
                    Form {
                        TextField("Style name", text: $newStyleName)
                    }
                    .navigationTitle("New Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showAddStyle = false } label: {
                                Label("Cancel", systemImage: "xmark")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                model.addStyle(newStyleName)
                                showAddStyle = false
                                newStyleName = ""
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                            .disabled(newStyleName.isEmpty)
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
            .sheet(item: $editingStyle) { style in
                NavigationStack {
                    Form { TextField("Style name", text: $editedStyleName) }
                    .navigationTitle("Edit Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { editingStyle = nil } label: {
                                Label("Cancel", systemImage: "xmark")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                if let idx = model.styles.firstIndex(of: style) {
                                    model.styles[idx].name = editedStyleName
                                }
                                editingStyle = nil
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
}

struct WorkoutStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStyleListView()
    }
}
