//
//  ContentView.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    // Lista exemplo de exercícios
    @StateObject var model = ExerciseModel()
    
    // Função auxiliar para formatar TimeInterval em "HH:mm:ss" ou "mm:ss"
    private func formattedTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 60)
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach($model.list) { $exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: $exercise, model: model)) {
                        Text(exercise.name)
                    }
                }
            }
            .toolbar {
                Button {
                    model.adicionarExercicio("Novo Ex. \(model.list.count + 1)")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Meus Treinos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
