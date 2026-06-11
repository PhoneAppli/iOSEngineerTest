import UIKit

protocol AddTodoViewControllerDelegate: AnyObject {
    func addTodoViewController(_ vc: AddTodoViewController, didSave todo: Todo)
    func addTodoViewControllerDidCancel(_ vc: AddTodoViewController)
}

final class AddTodoViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!

    weak var delegate: AddTodoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        deadlinePicker.minimumDate = Date()
        saveButton.isEnabled = false
        contentTextView.layer.cornerRadius = 8
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.borderColor = UIColor.separator.cgColor
        contentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        titleField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    @objc private func textChanged() {
        let trimmed = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        saveButton.isEnabled = !trimmed.isEmpty
    }

    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        let selectedPriority: Todo.Priority
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0: selectedPriority = .high
        case 2: selectedPriority = .low
        default: selectedPriority = .medium
        }
        let todo = Todo(
            title: (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            content: contentTextView.text ?? "",
            deadline: deadlinePicker.date,
            priority: selectedPriority
        )
        delegate?.addTodoViewController(self, didSave: todo)
    }

    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        delegate?.addTodoViewControllerDidCancel(self)
    }
}
