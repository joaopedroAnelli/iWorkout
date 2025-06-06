//
//  iWorkoutApp.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

@main
struct iWorkoutApp: App {
    init() {
        _ = SharedData.shared
    }
    
    var body: some Scene {
        WindowGroup {
            WorkoutStyleListView()
        }
    }
}
