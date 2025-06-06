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
    /// Complete collection of workout styles shared between devices
    @Published var styles: [WorkoutStyle] = []

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
        #if os(iOS)
        if activationState == .activated {
            sendStyles(styles)
        }
        #endif
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let data = applicationContext["styles"] as? Data,
           let received = try? JSONDecoder().decode([WorkoutStyle].self, from: data) {
            DispatchQueue.main.async {
                self.styles = received
            }
        }
    }

    func sendStyles(_ styles: [WorkoutStyle]) {
        do {
            let data = try JSONEncoder().encode(styles)
            try WCSession.default.updateApplicationContext(["styles": data])
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
