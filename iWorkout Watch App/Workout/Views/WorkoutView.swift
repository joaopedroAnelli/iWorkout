//
//  WorkoutView.swift
//  iWorkout Watch App
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

/// Displays the exercises for a selected workout session
struct WorkoutView: View {
    @StateObject private var viewModel: WatchWorkoutViewModel

    init(styleIndex: Int, sessionIndex: Int) {
        _viewModel = StateObject(wrappedValue: WatchWorkoutViewModel(styleIndex: styleIndex,
                                                                    sessionIndex: sessionIndex))
    }
    
    var body: some View {
        VStack {
            if viewModel.showingRest {
                Text("Rest: \(viewModel.restTime)s")
                    .font(.title2)
            } else {
                if let session = viewModel.currentSession,
                   session.exercises.indices.contains(viewModel.currentIndex) {
                    Text(session.exercises[viewModel.currentIndex].name)
                        .font(.headline)
                        .padding()
                    Button {
                        viewModel.nextExercise()
                    } label: {
                        Label("Next", systemImage: "chevron.right")
                    }
                    .padding(.top, 10)
                } else {
                    Text("No exercise")
                        .padding()
                }
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(styleIndex: 0, sessionIndex: 0)
    }
}
