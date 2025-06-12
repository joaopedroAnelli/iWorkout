import Foundation

class WorkoutStyleListViewModel: ObservableObject {
    private static let storageKey = "workoutStyles"

    @Published var styles: [WorkoutStyle] = [] {
        didSet {
            save()
            SharedData.shared.styles = styles
            SharedData.shared.sendStyles(styles)
        }
    }

    init() {
        load()
    }

    func addStyle(_ name: String,
                  navigation: SessionNavigation = .weekday,
                  isActive: Bool = true,
                  activeUntil: Date? = nil) {
        styles.append(WorkoutStyle(name: name,
                                   sessions: [],
                                   navigation: navigation,
                                   isActive: isActive,
                                   activeUntil: activeUntil))
    }

    func updateStyle(_ style: WorkoutStyle) {
        if let index = styles.firstIndex(where: { $0.id == style.id }) {
            styles[index] = style
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(styles) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode([WorkoutStyle].self, from: data) {
            styles = saved
        } else {
            styles = []
        }
    }
}
