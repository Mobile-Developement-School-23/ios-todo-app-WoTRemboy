import Foundation

extension ToDoItem {
    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any],
              let id = data["id"] as? String,
              let taskText = data["taskText"] as? String,
              let createDateInt = data["createDate"] as? Int
        else {
            return nil
        }
        
        let createDate = Date(timeIntervalSince1970: TimeInterval(createDateInt))
        let completed = data["completed"] as? Bool
        let importance = (data["importance"] as? String).flatMap(Importance.init(rawValue:))
        let deadline = (data["deadline"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        let editDate = (data["editDate"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }

        return ToDoItem(id: id,
                        taskText: taskText,
                        importance: importance ?? .regular,
                        deadline: deadline,
                        completed: completed ?? false,
                        createDate: createDate,
                        editDate: editDate)
    }
    
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "taskText": taskText,
            "completed": completed
        ]
        
        if importance != .regular {
            dictionary["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            dictionary["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        dictionary["createDate"] = Int(createDate.timeIntervalSince1970)
        if let editDate = editDate {
            dictionary["editDate"] = Int(editDate.timeIntervalSince1970)
        }
        
        return dictionary
    }
}
