//
//  SharedData.swift
//  iWorkout
//
//  Created by João Anelli on 6/3/25.
//

import Foundation
import WatchConnectivity

class SharedData: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = SharedData()
    @Published var list: [String] = []

    private override init() {
        super.init()
        activateSession()
    }

    func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // nada aqui
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let listaRecebida = applicationContext["exercicios"] as? [String] {
            DispatchQueue.main.async {
                self.list = listaRecebida
            }
        }
    }

    func enviarLista(_ list: [String]) {
        do {
            try WCSession.default.updateApplicationContext(["exercises": list])
        } catch {
            print("Erro ao enviar contexto: \(error)")
        }
    }
    
    // → Este método é obrigatório em iOS, mas não existe no watchOS
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
       // nada extra a fazer
    }

    func sessionDidDeactivate(_ session: WCSession) {
       // reativa a sessão para o novo dispositivo emparelhado
       WCSession.default.activate()
    }
    #endif
}
