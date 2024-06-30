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

func checkConnection() -> Bool {
    guard let url = URL(string: "http://localhost:9090/todo/") else {
        return false
    }

    let semaphore = DispatchSemaphore(value: 0)
    var connectionValid: Bool = false

    let task = Task { () -> Bool in
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                return (200...299).contains(httpResponse.statusCode)
            }
        } catch {
            return false
        }
        return false
    }

    Task {
        connectionValid = await task.value
        semaphore.signal()
    }

    semaphore.wait()
    return connectionValid
}
 
func getDataFromAPI() async -> [ToDos] {
    let url = URL(string: "http://localhost:9090/todo/")
    
    guard let url = url else {
        return [
            ToDos(_id: "", title: "Error Loading Data", isCompleted: false),
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
                ToDos(_id: "", title: "Error Loading Data", isCompleted: false),
            ]
        }
    } catch {
        return [
            ToDos(_id: "", title: "Error Loading Data", isCompleted: false),
        ]
    }
}

func updateDataToAPI(todoItem: ToDos) async -> Bool {
    
    guard let url = URL(string: "http://localhost:9090/todo/") else {
        return false
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let todoDict: [String: Any] = [
        "_id": todoItem._id,
        "title": todoItem.title,
        "isCompleted": todoItem.isCompleted
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: todoDict, options: [])
        request.httpBody = jsonData

        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            return true
        } else {
            return false
        }
    } catch {
        return false
    }
}
