import Foundation

class WorkoutStyleListViewModel: ObservableObject {
    private static let storageKey = "workoutStyles"
    private var expirationTimer: Timer?

    @Published var styles: [WorkoutStyle] = [] {
        didSet {
            save()
            SharedData.shared.styles = styles
            SharedData.shared.sendStyles(styles)
        }
    }

    /// Currently active workout style if not expired
    var activeStyle: WorkoutStyle? {
        styles.first { style in
            style.isActive && (style.activeUntil == nil || style.activeUntil! > Date())
        }
    }

    init() {
        load()
        startExpirationTimer()
    }

    func addStyle(_ name: String, isActive: Bool = false, activeUntil: Date? = nil) {
        var newStyle = WorkoutStyle(name: name, isActive: isActive, activeUntil: activeUntil)
        if isActive {
            for idx in styles.indices {
                styles[idx].isActive = false
                styles[idx].activeUntil = nil
            }
        }
        styles.append(newStyle)
    }

    func updateStyle(_ style: WorkoutStyle) {
        guard let index = styles.firstIndex(where: { $0.id == style.id }) else { return }
        var updated = styles
        for idx in updated.indices {
            if idx == index {
                updated[idx] = style
            } else if style.isActive {
                updated[idx].isActive = false
                updated[idx].activeUntil = nil
            }
        }
        styles = updated
    }

    /// Activate the given style until the specified date
    func activateStyle(_ style: WorkoutStyle, until: Date?) {
        var updated = styles
        for idx in updated.indices {
            if updated[idx].id == style.id {
                updated[idx].isActive = true
                updated[idx].activeUntil = until
            } else if updated[idx].isActive {
                updated[idx].isActive = false
                updated[idx].activeUntil = nil
            }
        }
        styles = updated
    }

    /// Manually deactivate the given style
    func deactivateStyle(_ style: WorkoutStyle) {
        if let idx = styles.firstIndex(where: { $0.id == style.id }) {
            styles[idx].isActive = false
            styles[idx].activeUntil = nil
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(styles) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    /// Remove active flag from styles whose expiration has passed
    @objc private func expireActiveStyles() {
        var updated = styles
        var changed = false
        for idx in updated.indices {
            if updated[idx].isActive,
               let until = updated[idx].activeUntil,
               until <= Date() {
                updated[idx].isActive = false
                updated[idx].activeUntil = nil
                changed = true
            }
        }
        if changed { styles = updated }
    }

    private func startExpirationTimer() {
        expirationTimer?.invalidate()
        expirationTimer = Timer.scheduledTimer(timeInterval: 60,
                                               target: self,
                                               selector: #selector(expireActiveStyles),
                                               userInfo: nil,
                                               repeats: true)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode([WorkoutStyle].self, from: data) {
            styles = saved
        } else {
            styles = []
        }
        expireActiveStyles()
    }
}
