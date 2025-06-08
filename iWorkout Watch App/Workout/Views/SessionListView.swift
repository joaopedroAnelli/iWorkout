import SwiftUI

/// Lists sessions for the chosen workout style
struct SessionListView: View {
    let styleIndex: Int
    @ObservedObject var shared = SharedData.shared

    var body: some View {
        let style = shared.styles[styleIndex]
        List {
            if style.sessions.isEmpty {
                Text("You haven't added sessions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(style.sessions.indices, id: \.self) { idx in
                    NavigationLink(style.sessions[idx].name) {
                        WorkoutView(styleIndex: styleIndex, sessionIndex: idx)
                    }
                }
            }
        }
        .navigationTitle(style.name)
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(styleIndex: 0)
    }
}

