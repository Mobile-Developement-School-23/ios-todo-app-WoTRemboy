import Foundation

extension ToDoItem {
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ";")
        guard components.count >= 3,
              components[0] != "",   // id check
              components[1] != "",   // taskText check
              components[5] != ""    // createDate check
        else {
            return nil
        }
        
        let id = components[0]
        let taskText = components[1]
        
        guard let createDateInt = Int(components[5]) else { return nil }
        let createDate = Date(timeIntervalSince1970: TimeInterval(createDateInt))
        
        let completed = components[3] == "true"
        
        let importanceRawValue = components[3]
        let importance = Importance(rawValue: importanceRawValue) ?? .regular
        
        let deadlineInt = components[4]
        let deadline = Int(deadlineInt).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        let editDateInt = components[6]
        let editDate = Int(editDateInt).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        return ToDoItem(id: id,
                        taskText: taskText,
                        importance: importance,
                        deadline: deadline,
                        completed: completed,
                        createDate: createDate,
                        editDate: editDate)
    }
    
    var csv: String {
        var csvComponents: [String] = [
            id,
            taskText,
            "\(Int(createDate.timeIntervalSince1970))",
            "\(completed)",
            importance != .regular ? importance.rawValue : "",
            deadline != nil ? "\(Int(deadline!.timeIntervalSince1970))" : "",
            editDate != nil ? "\(Int(editDate!.timeIntervalSince1970))" : ""
        ]
        
        let csvString = csvComponents.joined(separator: ";")
        return csvString
    }
}

