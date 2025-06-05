import SwiftUI

/// Picker para selecionar horas, minutos e segundos.
/// Mantém o valor sincronizado via `TimeInterval`.
struct CountdownTimerPicker: View {
    @Binding var duration: TimeInterval

    private var hoursBinding: Binding<Int> {
        Binding<Int>(
            get: { Int(duration) / 3600 },
            set: { newValue in
                let minutes = (Int(duration) % 3600) / 60
                let seconds = Int(duration) % 60
                duration = TimeInterval(newValue * 3600 + minutes * 60 + seconds)
            }
        )
    }

    private var minutesBinding: Binding<Int> {
        Binding<Int>(
            get: { (Int(duration) % 3600) / 60 },
            set: { newValue in
                let hours = Int(duration) / 3600
                let seconds = Int(duration) % 60
                duration = TimeInterval(hours * 3600 + newValue * 60 + seconds)
            }
        )
    }

    private var secondsBinding: Binding<Int> {
        Binding<Int>(
            get: { Int(duration) % 60 },
            set: { newValue in
                let hours = Int(duration) / 3600
                let minutes = (Int(duration) % 3600) / 60
                duration = TimeInterval(hours * 3600 + minutes * 60 + newValue)
            }
        )
    }

    var body: some View {
        HStack {
            Picker("Horas", selection: hoursBinding) {
                ForEach(0..<24, id: \.self) { Text("\($0)h").tag($0) }
            }
            .frame(maxWidth: .infinity)
            .clipped()

            Picker("Minutos", selection: minutesBinding) {
                ForEach(0..<60, id: \.self) { Text("\($0)m").tag($0) }
            }
            .frame(maxWidth: .infinity)
            .clipped()

            Picker("Segundos", selection: secondsBinding) {
                ForEach(0..<60, id: \.self) { Text("\($0)s").tag($0) }
            }
            .frame(maxWidth: .infinity)
            .clipped()
        }
        .pickerStyle(.wheel)
    }
}
