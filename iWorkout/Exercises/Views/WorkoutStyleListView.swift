import SwiftUI

/// Root view listing all workout styles
struct WorkoutStyleListView: View {
    @StateObject private var model = WorkoutStyleListViewModel()

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
                Button(action: addStyle) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func addStyle() {
        let title = String(format: NSLocalizedString("Style %d", comment: "Default style name"), model.styles.count + 1)
        model.addStyle(title)
    }
}

struct WorkoutStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStyleListView()
    }
}
