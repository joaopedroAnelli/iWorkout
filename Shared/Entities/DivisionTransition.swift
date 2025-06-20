import Foundation

enum DivisionTransition: String, Codable, CaseIterable, Identifiable {
    case weekly
    case sequential

    var id: Self { self }

    var localized: String {
        switch self {
        case .weekly:
            return NSLocalizedString("Fixed to Weekdays", comment: "")
        case .sequential:
            return NSLocalizedString("One After Another", comment: "")
        }
    }
}
