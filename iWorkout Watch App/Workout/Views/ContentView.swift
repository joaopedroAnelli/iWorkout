//
//  ContentView.swift
//  iWorkout Watch App
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WatchWorkoutViewModel()
    
    var body: some View {
        VStack {
            Picker("Style", selection: $viewModel.styleIndex) {
                ForEach(viewModel.shared.styles.indices, id: \.self) { idx in
                    Text(viewModel.shared.styles[idx].name).tag(idx)
                }
            }
            Picker("Session", selection: $viewModel.sessionIndex) {
                if viewModel.shared.styles.indices.contains(viewModel.styleIndex) {
                    let style = viewModel.shared.styles[viewModel.styleIndex]
                    ForEach(style.sessions.indices, id: \.self) { idx in
                        Text(style.sessions[idx].name).tag(idx)
                    }
                }
            }

            if viewModel.showingRest {
                Text("Rest: \(viewModel.restTime)s")
                    .font(.title2)
            } else {
                if let session = viewModel.currentSession,
                   session.exercises.indices.contains(viewModel.currentIndex) {
                    Text(session.exercises[viewModel.currentIndex].name)
                        .font(.headline)
                        .padding()
                    Button("Next") {
                        viewModel.nextExercise()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
