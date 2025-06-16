import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""
    @State private var editingStyle: WorkoutStyle?
    @State private var editedStyleName = ""
    @State private var editedIsActive = false
    @State private var editedActiveUntil = Date()

    @State private var newStyleIsActive = false
    @State private var newStyleActiveUntil = Date()

    var body: some View {
        NavigationStack {
            List {
                if model.styles.isEmpty {
                    Text("You haven't added workouts yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(model.styles.indices, id: \.self) { idx in
                        let style = model.styles[idx]
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
                                editedStyleName = style.name
                                editedIsActive = style.isActive
                                editedActiveUntil = style.activeUntil ?? Date()
                                editingStyle = style
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
                    Button {
                        newStyleIsActive = false
                        newStyleActiveUntil = Date()
                        showAddStyle = true
                    } label: {
                        Label("Add Workout", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddStyle) {
                NavigationStack {
                    Form {
                        TextField("Style name", text: $newStyleName)
                        Toggle("Active", isOn: $newStyleIsActive)
                        if newStyleIsActive {
                            DatePicker("Active Until", selection: $newStyleActiveUntil, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        }
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
                                model.addStyle(newStyleName, isActive: newStyleIsActive, activeUntil: newStyleIsActive ? newStyleActiveUntil : nil)
                                showAddStyle = false
                                newStyleName = ""
                                newStyleIsActive = false
                                newStyleActiveUntil = Date()
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
                    Form {
                        TextField("Style name", text: $editedStyleName)
                        Toggle("Active", isOn: $editedIsActive)
                        if editedIsActive {
                            DatePicker("Active Until", selection: $editedActiveUntil, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        }
                    }
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
                                    model.updateStyle(WorkoutStyle(id: style.id,
                                                                   name: editedStyleName,
                                                                   sessions: style.sessions,
                                                                   isActive: editedIsActive,
                                                                   activeUntil: editedIsActive ? editedActiveUntil : nil))
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
