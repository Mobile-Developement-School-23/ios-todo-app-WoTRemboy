

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

//        let importance: Importance?
//        if let importanceRawValue = data["importance"] as? String {
//            importance = Importance(rawValue: importanceRawValue)
//        }
        
        let deadline = (data["deadline"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        let editDate = (data["editDate"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
//        let deadline: Date?
//        if let deadlineInt = data["deadline"] as? Int {
//            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
//        }
        
//        let editDate: Date?
//        if let editDateInt = data["editDate"] as? Int {
//            editDate = Date(timeIntervalSince1970: TimeInterval(editDateInt))
//        }
        
        return ToDoItem(id: id, taskText: taskText, importance: importance ?? .regular, deadline: deadline, completed: completed ?? false, createDate: createDate, editDate: editDate)
    }
    
    var json: Any {
        var cont: [String: Any] = [
            "id": id,
            "taskText": taskText,
            "completed": completed
        ]
        
        if importance != .regular {
            cont["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            cont["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        cont["createDate"] = Int(createDate.timeIntervalSince1970)
        if let editDate = editDate {
            cont["editDate"] = Int(editDate.timeIntervalSince1970)
        }
        
        return cont
    }
}
