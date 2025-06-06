import Foundation

class WorkoutSessionViewModel: ObservableObject {
    @Published var style: WorkoutStyle {
        didSet { onUpdate(style) }
    }

    private let onUpdate: (WorkoutStyle) -> Void

    init(style: WorkoutStyle, onUpdate: @escaping (WorkoutStyle) -> Void = { _ in }) {
        self.style = style
        self.onUpdate = onUpdate
    }

    var sessions: [WorkoutSession] {
        get { style.sessions }
        set { style.sessions = newValue }
    }

    func addSession(_ name: String) {
        style.sessions.append(WorkoutSession(name: name))
    }

    func updateSession(_ session: WorkoutSession) {
        if let idx = style.sessions.firstIndex(where: { $0.id == session.id }) {
            style.sessions[idx] = session
        }
    }

    func removeSession(_ session: WorkoutSession) {
        if let idx = style.sessions.firstIndex(of: session) {
            style.sessions.remove(at: idx)
        }
    }
}
