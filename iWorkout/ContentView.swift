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

    var body: some View {
        NavigationView {
            List(model.list, id: \.self) { item in
                NavigationLink(destination: DetalheExercicioView(nome: item, model: model)) {
                    Text(item)
                }
            }.toolbar {
                Button {
                    model.adicionarExercicio("Novo Ex. \($model.list.count + 1)")
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Meus Treinos")
        }
    }
}

struct DetalheExercicioView: View {
    let nome: String
    
    @ObservedObject var model: ExerciseModel

    var body: some View {
        VStack {
            Text(nome)
                .font(.largeTitle)
                .padding()
            // Aqui o temporizador de descanso será adicionado depois
            Spacer()
        }
        .navigationTitle(nome)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
