import UIKit
import Foundation

struct ToDos: Identifiable{
    let id = UUID()
    var _id: String
    var title: String
    var isCompleted: Bool = false
    
    static func fetchToDos() async -> [ToDos] {
        return await getDataFromAPI()
    }
}

 
func getDataFromAPI() async -> [ToDos] {
    let url = URL(string: "http://localhost:9090/todo/")
    
    guard let url = url else {
        return [
            ToDos(_id: "1", title: "Error Loading Data", isCompleted: false),
        ]
    }
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>] {
            return jsonArray.map { dict in
                ToDos(_id: (dict["_id"] as? [String: Any])?["$oid"] as? String ?? "", title: dict["title"] as? String ?? "", isCompleted: dict["isCompleted"] as? Bool ?? false)
            }
        } else {
            return [
                ToDos(_id: "1", title: "Error Loading Data", isCompleted: false),
            ]
        }
    } catch {
        print("Error: \(error)")
        return [
            ToDos(_id: "1", title: "Error Loading Data", isCompleted: false),
        ]
    }
}
