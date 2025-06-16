import SwiftUI

struct WorkoutSessionForm: View {
    var titleKey: LocalizedStringKey
    @Binding var name: String
    @Binding var weekday: Weekday
    var showWeekday: Bool
    var onCancel: () -> Void
    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Session name", text: $name)
                if showWeekday {
                    Picker("Weekday", selection: $weekday) {
                        ForEach(Weekday.allCases) { day in
                            Text(day.localized).tag(day)
                        }
                    }
                }
            }
            .navigationTitle(titleKey)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: onCancel) {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: onSave) {
                        Label("Save", systemImage: "checkmark")
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

