import SwiftUI
import UIKit

struct TodoDetailScreen: UIViewControllerRepresentable {
    let todo: Todo

    func makeUIViewController(context: Context) -> TodoDetailViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TodoDetailViewController") as! TodoDetailViewController
        vc.todo = todo
        return vc
    }

    func updateUIViewController(_ vc: TodoDetailViewController, context: Context) {}
}
