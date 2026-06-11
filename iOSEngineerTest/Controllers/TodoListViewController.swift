import UIKit

final class TodoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var dataSource: UITableViewDiffableDataSource<String, UUID>!
    private var todos: [Todo] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TODO"
        configureTableView()
        configureDataSource()
        configureFloatingButton()
        reload()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<String, UUID>(tableView: tableView) { [weak self] tableView, indexPath, todoId in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
            if let todo = self?.todos.first(where: { $0.id == todoId }) {
                cell.configure(with: todo)
            }
            return cell
        }
    }

    private func configureFloatingButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 56),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func reload() {
        todos = TodoStorage.loadAll().sorted { lhs, rhs in
            if lhs.deadline != rhs.deadline { return lhs.deadline < rhs.deadline }
            return lhs.createdAt > rhs.createdAt
        }
        var snapshot = NSDiffableDataSourceSnapshot<String, UUID>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(todos.map(\.id), toSection: "main")
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func didTapAdd() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nav = storyboard.instantiateViewController(withIdentifier: "AddTodoNavigation") as? UINavigationController,
              let addVC = nav.viewControllers.first as? AddTodoViewController else { return }
        addVC.delegate = self
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium
        }
        present(nav, animated: true)
    }

    @objc private func didPullToRefresh() {
        reload()
        refreshControl.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let detail = segue.destination as? TodoDetailViewController,
           let todo = sender as? Todo {
            detail.todo = todo
        }
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let todoId = dataSource.itemIdentifier(for: indexPath),
              let todo = todos.first(where: { $0.id == todoId }) else { return }
        performSegue(withIdentifier: "showDetail", sender: todo)
    }
}

extension TodoListViewController: AddTodoViewControllerDelegate {
    func addTodoViewController(_ vc: AddTodoViewController, didSave todo: Todo) {
        TodoStorage.save(todo)
        vc.dismiss(animated: true) { [weak self] in
            self?.reload()
        }
    }

    func addTodoViewControllerDidCancel(_ vc: AddTodoViewController) {
        vc.dismiss(animated: true)
    }
}
