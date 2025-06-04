//
//  CountdownTimerPicker.swift
//  iWorkout
//
//  Created by João Anelli on 6/4/25.
//


import SwiftUI

struct CountdownTimerPicker: UIViewRepresentable {
    /// Quantidade de segundos selecionados (binding ao SwiftUI)
    @Binding var duration: TimeInterval
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 1
        picker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.uiKitValueChanged(_:)),
            for: .valueChanged
        )
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        // Sincroniza a duração atualizada (em segundos) com o UIDatePicker
        uiView.countDownDuration = duration
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject {
        let parent: CountdownTimerPicker
        
        init(parent: CountdownTimerPicker) {
            self.parent = parent
        }
        
        @objc func uiKitValueChanged(_ sender: UIDatePicker) {
            // Atualiza o binding sempre que o usuário muda o valor
            parent.duration = sender.countDownDuration
        }
    }
}
