import SwiftUI

/// Lists sessions for the chosen workout style
struct SessionListView: View {
    let styleIndex: Int
    @ObservedObject var shared = SharedData.shared

    var body: some View {
        let style = shared.styles[styleIndex]
        List {
            ForEach(style.sessions.indices, id: \.self) { idx in
                NavigationLink(style.sessions[idx].name) {
                    WorkoutView(styleIndex: styleIndex, sessionIndex: idx)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("DarkBackground"))
        .navigationTitle(style.name)
        .toolbarBackground(Color("HeaderColor"), for: .navigationBar)
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(styleIndex: 0)
    }
}

