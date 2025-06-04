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
    
    @State private var indiceAtual = 0
    @State private var mostrandoDescanso = false
    @State private var tempoDescanso = 30

    var body: some View {
        VStack {
            if mostrandoDescanso {
                Text("Descanso: \(tempoDescanso)s")
                    .font(.title2)
            } else {
                if shared.list.indices.contains(indiceAtual) {
                    Text(shared.list[indiceAtual])
                        .font(.headline)
                        .padding()
                    Button("Próximo") {
                        if indiceAtual < shared.list.count - 1 {
                            indiceAtual += 1
                            startDescanso()
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

    func startDescanso() {
        mostrandoDescanso = true
        tempoDescanso = 30
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if tempoDescanso > 0 {
                tempoDescanso -= 1
            } else {
                mostrandoDescanso = false
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

