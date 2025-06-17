import Foundation
import SwiftUI
import Combine

class WatchWorkoutViewModel: ObservableObject {
    @Published var styleIndex: Int {
        didSet { resetProgress() }
    }
    @Published var sessionIndex: Int {
        didSet { resetProgress() }
    }
    @Published var currentIndex: Int = 0
    @Published var showingRest: Bool = false
    @Published var restTime: Int = 30

    @ObservedObject var shared = SharedData.shared
    private var timer: Timer?
    private var cancellable: AnyCancellable?

    init(styleIndex: Int, sessionIndex: Int) {
        self.styleIndex = styleIndex
        self.sessionIndex = sessionIndex
        // forward updates from SharedData so the view refreshes when
        // the exercise list changes
        cancellable = shared.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    convenience init() {
        self.init(styleIndex: 0, sessionIndex: 0)
    }

    func resetProgress() {
        currentIndex = 0
        showingRest = false
    }

    var currentSession: WorkoutSession? {
        guard shared.styles.indices.contains(styleIndex) else { return nil }
        let style = shared.styles[styleIndex]
        guard style.sessions.indices.contains(sessionIndex) else { return nil }
        return style.sessions[sessionIndex]
    }

    func nextExercise() {
        guard let session = currentSession,
              currentIndex < session.exercises.count - 1 else { return }
        currentIndex += 1
        startRest()
    }

    func startRest() {
        showingRest = true
        restTime = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.restTime > 0 {
                self.restTime -= 1
            } else {
                self.showingRest = false
                timer.invalidate()
            }
        }
    }

    func completeWorkout() {
        guard shared.styles.indices.contains(styleIndex) else { return }
        var style = shared.styles[styleIndex]
        guard style.sessions.indices.contains(sessionIndex) else { return }
        if style.transition == .sequential {
            style.lastCompletedSessionId = style.sessions[sessionIndex].id
            shared.styles[styleIndex] = style
            shared.sendStyles(shared.styles)
        }
    }
}
