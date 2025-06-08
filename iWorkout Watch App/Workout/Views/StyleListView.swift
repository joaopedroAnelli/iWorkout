import SwiftUI

/// Lists available workout styles on Apple Watch
struct StyleListView: View {
    @ObservedObject var shared = SharedData.shared

    var body: some View {
        List {
            if shared.styles.isEmpty {
                Text("You haven't added workouts yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(shared.styles.indices, id: \.self) { idx in
                    NavigationLink(shared.styles[idx].name) {
                        SessionListView(styleIndex: idx)
                    }
                }
            }
        }
        .navigationTitle("Workouts")
    }
}

struct StyleListView_Previews: PreviewProvider {
    static var previews: some View {
        StyleListView()
    }
}

