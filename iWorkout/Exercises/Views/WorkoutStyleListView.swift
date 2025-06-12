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
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    Button { showAddStyle = true } label: {
                        Image(systemName: "plus")
                    }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                }.background(.thinMaterial)
            }
            .sheet(isPresented: $showAddStyle) {
                NavigationView {
                    Form {
                        TextField("Style name", text: $newStyleName)
                    }
                    .navigationTitle("New Style")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button { showAddStyle = false } label: {
                                Image(systemName: "xmark")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                model.addStyle(newStyleName)
                                showAddStyle = false
                                newStyleName = ""
                            } label: {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(.borderedProminent)
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
                            Button { editingStyle = nil } label: {
                                Image(systemName: "xmark")
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                if let idx = model.styles.firstIndex(of: style) {
                                    model.styles[idx].name = editedStyleName
                                }
                                editingStyle = nil
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.borderedProminent)
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
