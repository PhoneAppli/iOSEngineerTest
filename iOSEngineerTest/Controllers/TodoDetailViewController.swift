import UIKit

final class TodoDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!

    var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "詳細"
        guard let todo else { return }
        titleLabel.text = todo.title
        contentLabel.text = todo.content.isEmpty ? "（なし）" : todo.content
        deadlineLabel.text = DateFormatter.todoDeadline.string(from: todo.deadline)
    }
}
