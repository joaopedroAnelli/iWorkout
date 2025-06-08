//
//  iWorkoutApp.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

@main
struct iWorkoutApp: App {
    @State private var showSendConfirm = false

    init() {
        _ = SharedData.shared
    }

    var body: some Scene {
        WindowGroup {
            WorkoutStyleListView()
                .onShake { showSendConfirm = true }
                .alert(NSLocalizedString("Send to Apple Watch?", comment: ""),
                       isPresented: $showSendConfirm) {
                    Button(NSLocalizedString("Send", comment: "")) {
                        SharedData.shared.sendStyles(SharedData.shared.styles)
                    }
                    Button(NSLocalizedString("Cancel", comment: ""),
                           role: .cancel) { }
                }
        }
    }
}
