import Foundation
import Combine

class ToDosViewModel: ObservableObject {
    @Published var todos: [ToDos] = []
    
    init() {
        fetchToDos()
    }
    
    func fetchToDos() {
        Task {
            let fetchedToDos = await getDataFromAPI()
            DispatchQueue.main.async {
                self.todos = fetchedToDos
            }
        }
    }
    
    func setCompleted(todoItem: ToDos) -> ToDos {
        var updatedTodo = todoItem
        updatedTodo.isCompleted.toggle()
        return updatedTodo
    }
}
