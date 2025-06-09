import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""
    @State private var newStyleActive = true
    @State private var newActiveUntil = Date()
    @State private var editingStyle: WorkoutStyle?
    @State private var editedStyleName = ""
    @State private var editedStyleActive = true
    @State private var editedActiveUntil = Date()

    var body: some View {
        NavigationView {
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
                                editedStyleActive = style.isActive
                                editedActiveUntil = style.activeUntil ?? Date()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.yellow)
                        }
                    }
                }
            }
            .navigationTitle("Workouts")
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button("Add Workout") { showAddStyle = true }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                }.background(.thinMaterial)
            }
            .sheet(isPresented: $showAddStyle) {
                NavigationView {
                    WorkoutStyleForm(name: $newStyleName,
                                     isActive: $newStyleActive,
                                     activeUntil: $newActiveUntil)
                    .navigationTitle("New Workout")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddStyle = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                model.addStyle(newStyleName,
                                               isActive: newStyleActive,
                                               activeUntil: newStyleActive ? newActiveUntil : nil)
                                showAddStyle = false
                                newStyleName = ""
                                newStyleActive = true
                                newActiveUntil = Date()
                            }
                            .disabled(newStyleName.isEmpty)
                        }
                    }
                }
            }
            .sheet(item: $editingStyle) { style in
                NavigationView {
                    WorkoutStyleForm(name: $editedStyleName,
                                     isActive: $editedStyleActive,
                                     activeUntil: $editedActiveUntil)
                    .navigationTitle("Edit Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { editingStyle = nil }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let idx = model.styles.firstIndex(of: style) {
                                    model.styles[idx].name = editedStyleName
                                    model.styles[idx].isActive = editedStyleActive
                                    model.styles[idx].activeUntil = editedStyleActive ? editedActiveUntil : nil
                                }
                                editingStyle = nil
                            }
                            .disabled(editedStyleName.isEmpty)
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
