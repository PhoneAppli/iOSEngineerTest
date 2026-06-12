import SwiftUI

struct TodoListView: View {
    @State private var viewModel = TodoListViewModel()
    @State private var presentedTodo: Todo?
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List(viewModel.todos) { todo in
                Button { presentedTodo = todo } label: {
                    TodoRow(todo: todo)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("TODO")
            .refreshable { viewModel.reload() }
            .overlay(alignment: .bottomTrailing) {
                AddFloatingButton { showingAdd = true }
                    .padding(16)
            }
            .navigationDestination(item: $presentedTodo) { todo in
                TodoDetailScreen(todo: todo)
            }
            .sheet(isPresented: $showingAdd) {
                AddTodoSheet(
                    onSave: { viewModel.add($0); showingAdd = false },
                    onCancel: { showingAdd = false }
                )
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .onAppear { viewModel.reload() }
        }
    }
}

private struct TodoRow: View {
    let todo: Todo
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: todo.priority.badgeURL) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: { Color.clear }
            .frame(width: 90, height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                Text(DateFormatter.todoDeadline.string(from: todo.deadline))
                    .foregroundStyle(todo.deadline < Date() ? .red : .secondary)
                    .font(.subheadline)
            }
        }
    }
}

private struct AddFloatingButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2.weight(.medium))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue, in: Circle())
                .shadow(radius: 6, y: 3)
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
