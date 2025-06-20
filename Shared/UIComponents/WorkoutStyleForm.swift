import SwiftUI

struct WorkoutStyleForm: View {
    @Binding var name: String
    @Binding var transition: DivisionTransition
    @Binding var isActive: Bool
    @Binding var activeUntil: Date

    var body: some View {
        Form {
            TextField("Style name", text: $name)
            Toggle("Active", isOn: $isActive)
            if isActive {
                DatePicker("Active Until", selection: $activeUntil, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }
            Section(header: Text("About Sessions")) {
                Picker("Session Progression", selection: $transition) {
                    ForEach(DivisionTransition.allCases) { Text($0.localized).tag($0) }
                }
                .help(Text("Session Progression Help"))

                Text("Session Progression Help")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .animation(.default, value: isActive)
    }
}
