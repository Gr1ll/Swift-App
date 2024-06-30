import SwiftUI

struct AddToDoView: View {
    @ObservedObject var viewModel: ToDosViewModel

    @Binding var isPresented: Bool;
    @Binding var newTodoTitle: String;

    var body: some View {
        VStack {
            Text("Add New Todo")
                .font(.headline)
                .padding()

            TextField("Todo Title", text: $newTodoTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Cancel") {
                    isPresented = false
                    newTodoTitle = ""
                }
                .padding()

                Spacer()

                Button("Add") {
                    viewModel.addItem(todoTitle: newTodoTitle);
                    newTodoTitle = "";
                    isPresented = false
                }
                .padding()
            }
        }
        .padding()
    }
}

struct AddToDoView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoView(viewModel: ToDosViewModel(), isPresented: .constant(true), newTodoTitle: .constant(""))
    }
}
