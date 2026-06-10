import Foundation

extension Todo.Priority {
    var badgeURL: URL {
        switch self {
        case .high:   return Self.highBadgeURL
        case .medium: return Self.mediumBadgeURL
        case .low:    return Self.lowBadgeURL
        }
    }

    private static let highBadgeURL   = URL(string: "https://img.shields.io/badge/review-high-red.png")!
    private static let mediumBadgeURL = URL(string: "https://img.shields.io/badge/review-medium-green.png")!
    private static let lowBadgeURL    = URL(string: "https://img.shields.io/badge/review-low-blue.png")!
}
