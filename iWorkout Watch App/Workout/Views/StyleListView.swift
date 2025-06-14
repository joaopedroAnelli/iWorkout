import SwiftUI

/// Lists available workout styles on Apple Watch
struct StyleListView: View {
    @ObservedObject var shared = SharedData.shared

    var body: some View {
        List {
            if let active = shared.styles.first(where: { $0.isActive && ($0.activeUntil == nil || $0.activeUntil! > Date()) }) {
                Section(header: Text("Active")) {
                    HStack {
                        Text(active.name)
                        Spacer()
                        if let until = active.activeUntil {
                            Text(timeRemaining(until: until))
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                    }
                }
            }

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

    private func timeRemaining(until date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: Date(), to: date) ?? ""
    }
}

struct StyleListView_Previews: PreviewProvider {
    static var previews: some View {
        StyleListView()
    }
}

