import SwiftUI

struct WorkoutStyleForm: View {
    @Binding var name: String
    @Binding var navigation: SessionNavigation
    @Binding var isActive: Bool
    @Binding var activeUntil: Date

    var body: some View {
        Form {
            TextField("Style name", text: $name)
            Picker("Navigation", selection: $navigation) {
                Text("Weekday").tag(SessionNavigation.weekday)
                Text("Sequential").tag(SessionNavigation.sequential)
            }
            .pickerStyle(.segmented)
            Toggle("Active", isOn: $isActive)
            if isActive {
                DatePicker("Active Until", selection: $activeUntil, displayedComponents: .date)
            }
        }
    }
}

struct WorkoutStyleForm_Previews: PreviewProvider {
    @State static private var name = "Sample"
    @State static private var navigation = SessionNavigation.weekday
    @State static private var isActive = true
    @State static private var date = Date()

    static var previews: some View {
        WorkoutStyleForm(name: $name,
                         navigation: $navigation,
                         isActive: $isActive,
                         activeUntil: $date)
    }
}
