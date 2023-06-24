

import Foundation

struct ToDoItem {
    let id: String
    let taskText: String
    let importance: Importance
    let deadline: Date?
    let completed: Bool
    let createDate: Date
    let editDate: Date?
    
    // MARK: Initializer considering default values ​​for properties and field values
    
    init(id: String = UUID().uuidString, taskText: String, importance: Importance, deadline: Date? = nil, completed: Bool = false, createDate: Date = Date(), editDate: Date? = nil) {
        self.id = id
        self.taskText = taskText
        self.importance = importance
        self.deadline = deadline
        self.completed = completed
        self.createDate = createDate
        self.editDate = editDate
    }
    
    func update(taskText: String, importance: Importance, deadline: Date?) -> ToDoItem {
        ToDoItem(id: self.id,
                 taskText: taskText,
                 importance: importance,
                 deadline: deadline,
                 completed: self.completed,
                 createDate: self.createDate,
                 editDate: Date())
      }
}

enum Importance: String {
    case unimportant
    case regular
    case important
}


