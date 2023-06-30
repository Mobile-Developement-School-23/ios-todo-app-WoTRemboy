import Foundation

extension ToDoItem {
    static func parse(csv: String) -> ToDoItem? {
        let components = csv.components(separatedBy: ";")
        guard components.count >= 6,
              components[0] != "",   // id field check
              components[1] != "",   // taskText field check
              components[5] != ""    // createDate field check
        else {
            return nil
        }
        
        let id = components[0]
        let taskText = components[1]
        
        let importanceRawValue = components[2]
        let importance = Importance(rawValue: importanceRawValue) ?? .regular
        
        var deadline: Date? = nil
        if let deadlineInt = Int(components[3]) {
            deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))
        }
        
        let completed = Bool(components[4]) ?? false
        
        guard let createDateInt = Int(components[5]) else { return nil }
        let createDate = Date(timeIntervalSince1970: TimeInterval(createDateInt))
        
        var editDate: Date?
        if components[6] != "" {
            let editDateString = components[6]
            editDate = Int(editDateString).flatMap { timestamp -> Date? in
                return Date(timeIntervalSince1970: TimeInterval(timestamp))
            }
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
        let csvComponents: [String] = [
            id,
            taskText,
            importance != .regular ? importance.rawValue : "",
            deadline != nil ? "\(Int(deadline!.timeIntervalSince1970))" : "",
            "\(completed)",
            "\(Int(createDate.timeIntervalSince1970))",
            editDate != nil ? "\(Int(editDate!.timeIntervalSince1970))" : ""
        ]
        
        let csvString = csvComponents.joined(separator: ";")
        return csvString
    }
}
