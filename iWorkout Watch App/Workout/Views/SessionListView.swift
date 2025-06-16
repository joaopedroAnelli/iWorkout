import SwiftUI

/// Lists sessions for the chosen workout style
struct SessionListView: View {
    let styleIndex: Int
    @ObservedObject var shared = SharedData.shared
    @State private var selection: Int?

    var body: some View {
        let style = shared.styles[styleIndex]
        List(selection: $selection) {
            if style.sessions.isEmpty {
                Text("You haven't added sessions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(style.sessions.indices, id: \.self) { idx in
                    NavigationLink(style.sessions[idx].name,
                                   tag: idx,
                                   selection: $selection) {
                        WorkoutView(styleIndex: styleIndex, sessionIndex: idx)
                    }
                }
            }
        }
        .navigationTitle(style.name)
        .onAppear {
            switch style.transition {
            case .weekly:
                let weekday = Calendar.current.component(.weekday, from: Date())
                let mapped = Weekday.allCases[(weekday + 5) % 7]
                if let idx = style.sessions.firstIndex(where: { $0.weekday == mapped }) {
                    selection = idx
                }
            case .sequential:
                if style.sessions.indices.contains(style.currentIndex) {
                    selection = style.currentIndex
                }
            }
        }
    }
}

struct SessionListView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView(styleIndex: 0)
    }
}

