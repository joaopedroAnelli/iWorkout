import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()
    @State private var showAddStyle = false
    @State private var newStyleName = ""

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
                    }
                    .onDelete { indexSet in
                        model.styles.remove(atOffsets: indexSet)
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
        }
    }
}

struct WorkoutStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStyleListView()
    }
}
