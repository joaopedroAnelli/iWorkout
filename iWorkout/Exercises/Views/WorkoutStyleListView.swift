import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""
    @State private var editingStyle: WorkoutStyle?
    @State private var editedStyleName = ""

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
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button("Add Workout") { showAddStyle = true }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.gray.opacity(0.3)),
                    alignment: .top
                )
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
            .sheet(item: $editingStyle) { style in
                NavigationView {
                    Form { TextField("Style name", text: $editedStyleName) }
                    .navigationTitle("Edit Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { editingStyle = nil }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let idx = model.styles.firstIndex(of: style) {
                                    model.styles[idx].name = editedStyleName
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
