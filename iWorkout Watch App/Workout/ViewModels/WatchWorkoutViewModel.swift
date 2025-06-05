import Foundation
import SwiftUI
import Combine

class WatchWorkoutViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var showingRest: Bool = false
    @Published var restTime: Int = 30

    @ObservedObject var shared = SharedData.shared
    private var timer: Timer?
    private var cancellable: AnyCancellable?

    init() {
        // forward updates from SharedData so the view refreshes when
        // the exercise list changes
        cancellable = shared.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func nextExercise() {
        guard currentIndex < shared.list.count - 1 else { return }
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
}
