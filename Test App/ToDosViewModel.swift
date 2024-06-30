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
        if checkConnection() == false {
            self.fetchToDos();
            return todoItem;
        }
        if todoItem._id == "" {
            self.fetchToDos();
            return todoItem;
        }
        var newToDoItem = todoItem;
        newToDoItem.isCompleted.toggle();
        let updatedToDoItem = newToDoItem;
        Task {
            await updateDataToAPI(todoItem: updatedToDoItem);
        }
        return updatedToDoItem;
    }
}
