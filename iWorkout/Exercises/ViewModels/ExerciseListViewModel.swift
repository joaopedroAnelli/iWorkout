import Foundation

class ExerciseListViewModel: ObservableObject {
    private var styleModel: WorkoutStyleListViewModel?
    private var styleIndex: Int = 0
    private var sessionIndex: Int = 0
    @Published var session: WorkoutSession {
        didSet { dirty = true }
    }

    private var dirty = false
    private let onUpdate: (WorkoutSession) -> Void

    var list: [Exercise] {
        get { session.exercises }
        set { session.exercises = newValue }
    }

    init(session: WorkoutSession, onUpdate: @escaping (WorkoutSession) -> Void) {
        self.session = session
        self.onUpdate = onUpdate
    }

    convenience init() {
        let model = WorkoutStyleListViewModel()
        if model.styles.isEmpty {
            let defaultStyle = WorkoutStyle(name: "Default",
                                           sessions: [WorkoutSession(name: "Session")])
            model.styles = [defaultStyle]
        }
        self.init(session: model.styles[0].sessions[0]) { updated in
            var style = model.styles[0]
            if style.sessions.isEmpty {
                style.sessions = [updated]
            } else {
                style.sessions[0] = updated
            }
            model.updateStyle(style)
        }
        self.styleModel = model
        self.styleIndex = 0
        self.sessionIndex = 0
    }

    func addExercise(name: String, sets: Int, restDuration: TimeInterval) {
        var updated = session
        let exercise = Exercise(sessionId: session.id, name: name, sets: sets, restDuration: restDuration)
        updated.exercises.append(exercise)
        session = updated
    }

    func removeExercise(_ exercise: Exercise) {
        var updated = session
        if let index = updated.exercises.firstIndex(of: exercise) {
            updated.exercises.remove(at: index)
            session = updated
        }
    }

    /// Persist pending changes back to the parent model and watch
    func commitIfNeeded() {
        guard dirty else { return }
        onUpdate(session)
        sendListToWatch()
        dirty = false
    }

    func sendListToWatch() {
        if let styles = styleModel?.styles {
            SharedData.shared.styles = styles
            SharedData.shared.sendStyles(styles)
        }
    }
}
