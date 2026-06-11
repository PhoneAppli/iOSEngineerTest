import SwiftUI
import UIKit

struct AddTodoSheet: UIViewControllerRepresentable {
    let onSave: (Todo) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onSave: onSave, onCancel: onCancel)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let nav = sb.instantiateViewController(withIdentifier: "AddTodoNavigation") as! UINavigationController
        if let add = nav.viewControllers.first as? AddTodoViewController {
            add.delegate = context.coordinator
        }
        return nav
    }

    func updateUIViewController(_ vc: UINavigationController, context: Context) {}

    final class Coordinator: NSObject, AddTodoViewControllerDelegate {
        let onSave: (Todo) -> Void
        let onCancel: () -> Void
        init(onSave: @escaping (Todo) -> Void, onCancel: @escaping () -> Void) {
            self.onSave = onSave; self.onCancel = onCancel
        }
        func addTodoViewController(_ vc: AddTodoViewController, didSave todo: Todo) { onSave(todo) }
        func addTodoViewControllerDidCancel(_ vc: AddTodoViewController) { onCancel() }
    }
}
