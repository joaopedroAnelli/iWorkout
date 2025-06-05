import Foundation

class ExerciseListViewModel: ObservableObject {
    private var styleModel: WorkoutStyleListViewModel?
    private var styleIndex: Int = 0
    private var sessionIndex: Int = 0
    @Published var session: WorkoutSession {
        didSet {
            onUpdate(session)
            sendListToWatch()
        }
    }

    private let onUpdate: (WorkoutSession) -> Void

    var list: [Exercise] {
        get { session.exercises }
        set { session.exercises = newValue }
    }

    init(session: WorkoutSession, onUpdate: @escaping (WorkoutSession) -> Void) {
        self.session = session
        self.onUpdate = onUpdate
        sendListToWatch()
    }

    convenience init() {
        let model = WorkoutStyleListViewModel()
        if model.styles.isEmpty {
            let defaultStyle = WorkoutStyle(name: "Default", sessions: [WorkoutSession(name: "Session")])
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

    func addExercise(_ name: String) {
        var updated = session
        updated.exercises.append(Exercise(name: name, sets: 3, restDuration: 60))
        session = updated
    }

    func removeExercise(_ exercise: Exercise) {
        var updated = session
        if let index = updated.exercises.firstIndex(of: exercise) {
            updated.exercises.remove(at: index)
            session = updated
        }
    }

    func sendListToWatch() {
        let names = list.map { $0.name }
        SharedData.shared.list = names
        SharedData.shared.sendList(names)
    }
}
