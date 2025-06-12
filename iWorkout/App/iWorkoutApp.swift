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
                    Button {
                        SharedData.shared.sendStyles(SharedData.shared.styles)
                    } label: {
                        Label(NSLocalizedString("Send", comment: ""), systemImage: "paperplane")
                    }
                    .buttonStyle(.borderedProminent)
                    Button(role: .cancel) { } label: {
                        Label(NSLocalizedString("Cancel", comment: ""), systemImage: "xmark")
                    }
                }
        }
    }
}
