import Foundation
import Observation

@Observable
final class TodoListViewModel {
    private(set) var todos: [Todo] = []

    private let storage = TodoStorage()

    func reload() {
        todos = storage.loadAll().sorted { $0.deadline < $1.deadline }
    }

    func add(_ todo: Todo) {
        storage.save(todo)
        reload()
    }
}
