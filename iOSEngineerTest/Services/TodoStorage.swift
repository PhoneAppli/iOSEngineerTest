import Foundation

enum TodoStorage {
    static let key = "iOSEngineerTest.todos.v1"

    static func loadAll() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Todo].self, from: data)) ?? []
    }

    static func saveAll(_ todos: [Todo]) {
        guard let data = try? JSONEncoder().encode(todos) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func append(_ todo: Todo) {
        var todos = loadAll()
        todos.append(todo)
        saveAll(todos)
    }
}
