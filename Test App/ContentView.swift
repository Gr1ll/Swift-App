import SwiftUI

struct ContentView: View {
    @StateObject
    private var viewModel = ToDosViewModel()
    
    @State private var showingAddTodoSheet = false
    @State private var newTodoTitle = ""

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
            .navigationBarItems(trailing: Button(action: {
                showingAddTodoSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTodoSheet) {
                AddToDoView(viewModel: viewModel, isPresented: $showingAddTodoSheet, newTodoTitle: $newTodoTitle)
            }
        }
    }
}

#Preview {
    ContentView()
}
