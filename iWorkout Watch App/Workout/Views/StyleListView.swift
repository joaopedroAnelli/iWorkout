import SwiftUI

/// Lists available workout styles on Apple Watch
struct StyleListView: View {
    @ObservedObject var shared = SharedData.shared

    var body: some View {
        List {
            ForEach(shared.styles.indices, id: \.self) { idx in
                NavigationLink(shared.styles[idx].name) {
                    SessionListView(styleIndex: idx)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkBackground"))
        .navigationTitle("Workouts")
        .toolbarBackground(Color("HeaderColor"), for: .navigationBar)
    }
}

struct StyleListView_Previews: PreviewProvider {
    static var previews: some View {
        StyleListView()
    }
}

