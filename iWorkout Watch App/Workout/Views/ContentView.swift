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
            if viewModel.showingRest {
                Text("Descanso: \(viewModel.restTime)s")
                    .font(.title2)
            } else {
                if viewModel.shared.list.indices.contains(viewModel.currentIndex) {
                    Text(viewModel.shared.list[viewModel.currentIndex])
                        .font(.headline)
                        .padding()
                    Button("Próximo") {
                        viewModel.nextExercise()
                    }
                    .padding(.top, 10)
                } else {
                    Text("Nenhum exercício")
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
