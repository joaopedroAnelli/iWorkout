//
//  ContentView.swift
//  iWorkout Watch App
//
//  Created by João Anelli on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    // Essa lista deve espelhar os exercícios do iPhone
    @ObservedObject var shared = SharedData.shared
    
    @State private var currentIndex = 0
    @State private var showingRest = false
    @State private var restTime = 30

    var body: some View {
        VStack {
            if showingRest {
                Text("Descanso: \(restTime)s")
                    .font(.title2)
            } else {
                if shared.list.indices.contains(currentIndex) {
                    Text(shared.list[currentIndex])
                        .font(.headline)
                        .padding()
                    Button("Próximo") {
                        if currentIndex < shared.list.count - 1 {
                            currentIndex += 1
                            startRest()
                        }
                    }
                    .padding(.top, 10)
                } else {
                    Text("Nenhum exercício")
                        .padding()
                }
            }
        }
        .onAppear {
            // Nada a fazer aqui por enquanto
        }
    }

    func startRest() {
        showingRest = true
        restTime = 30
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if restTime > 0 {
                restTime -= 1
            } else {
                showingRest = false
                timer.invalidate()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

