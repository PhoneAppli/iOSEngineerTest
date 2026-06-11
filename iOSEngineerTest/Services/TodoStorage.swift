import Foundation

final class TodoStorage {
    private let key = "iOSEngineerTest.todos.v1"

    func loadAll() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Todo].self, from: data)) ?? []
    }

    func saveAll(_ todos: [Todo]) {
        guard let data = try? JSONEncoder().encode(todos) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func save(_ todo: Todo) {
        var todos = loadAll()
        todos.append(todo)
        saveAll(todos)
    }
}
