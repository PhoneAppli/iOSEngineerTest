import Foundation

struct Todo: Codable, Hashable, Identifiable {
    enum Priority: String, Codable, CaseIterable {
        case high
        case medium
        case low

        var badgeURL: URL {
            switch self {
            case .high:
                return URL(string: "https://img.shields.io/badge/review-hight-red.png")!
            case .medium:
                return URL(string: "https://img.shields.io/badge/review-medium-green.png")!
            case .low:
                return URL(string: "https://img.shields.io/badge/review-low-blue.png")!
            }
        }
    }

    let id: UUID
    var title: String
    var content: String
    var deadline: Date
    var createdAt: Date
    var priority: Priority

    init(id: UUID = UUID(), title: String, content: String, deadline: Date, createdAt: Date = Date(), priority: Priority) {
        self.id = id
        self.title = title
        self.content = content
        self.deadline = deadline
        self.createdAt = createdAt
        self.priority = priority
    }
}
