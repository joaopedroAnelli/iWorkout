//
//  ContentView.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    // Lista exemplo de exercícios
    @StateObject var model = ExerciseListViewModel()
    @State private var exerciseToDelete: Exercise?
    @State private var showDeleteConfirm = false

    
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
                if model.list.isEmpty {
                    Text("Você ainda não adicionou exercícios")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach($model.list) { $exercise in
                        ExerciseRow(exercise: $exercise, model: model) {
                            exerciseToDelete = exercise
                            showDeleteConfirm = true

                        }
                    }
                }
            }
            .toolbar {
                Button {
                    model.addExercise("Novo Ex. \(model.list.count + 1)")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Meus Treinos")
            .alert("Excluir exercício?", isPresented: $showDeleteConfirm, presenting: exerciseToDelete) { exercise in
                Button("Excluir", role: .destructive) {
                    model.removeExercise(exercise)
                }
                Button("Cancelar", role: .cancel) { }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// A separate view for a single exercise row
struct ExerciseRow: View {
    @Binding var exercise: Exercise
    var model: ExerciseListViewModel
    var onDelete: () -> Void

    var body: some View {
        NavigationLink(destination: ExerciseDetailView(exercise: $exercise, model: model)) {
            Text(exercise.name)
        }
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
    }
}
