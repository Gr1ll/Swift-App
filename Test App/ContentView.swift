import SwiftUI

struct ContentView: View {
    @StateObject
    private var viewModel = ToDosViewModel()

    var body: some View {
        NavigationView{
            List($viewModel.todos){
                $todoItem in
                HStack{
                    Image(systemName: todoItem.isCompleted ? "largecircle.fill.circle" : "circle").imageScale(.large).foregroundColor(.accentColor)
                        .onTapGesture {
                            todoItem = viewModel.setCompleted(todoItem: todoItem)
                        }
                    Text(todoItem.title)
                    
                }
            }
            .navigationBarTitle("ToDo's", displayMode: .inline)
        }
    }
}

#Preview {
    ContentView()
}
