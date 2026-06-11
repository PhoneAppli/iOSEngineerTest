import UIKit

final class TodoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!

    private var imageLoadTask: Task<Void, Never>?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        badgeImageView.image = nil
    }

    func configure(with todo: Todo) {
        titleLabel.text = todo.title
        deadlineLabel.text = DateFormatter.todoDeadline.string(from: todo.deadline)
        deadlineLabel.textColor = todo.deadline < Date() ? .systemRed : .secondaryLabel
        loadBadgeImage(from: todo.priority.badgeURL)
    }

    private func loadBadgeImage(from url: URL) {
        imageLoadTask?.cancel()
        imageLoadTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled, let image = UIImage(data: data) else { return }
                await MainActor.run {
                    self?.badgeImageView.image = image
                }
            } catch {}
        }
    }
}

extension DateFormatter {
    static let todoDeadline: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()
}
