

import Foundation

struct ToDoItem {
    let id: String
    let taskText: String
    let importance: Importance
    let deadline: Date?
    let done: Bool
    let createDate: Date
    let editDate: Date?
    
    // инициализатор с учетом значений по умолчанию для свойств и значимости полей
    
    init(id: String = UUID().uuidString, taskText: String, importance: Importance, deadline: Date? = nil, done: Bool = false, createDate: Date = Date(), editDate: Date? = nil) {
        self.id = id
        self.taskText = taskText
        self.importance = importance
        self.deadline = deadline
        self.done = done
        self.createDate = createDate
        self.editDate = editDate
    }
}

enum Importance {
    case unimportant
    case regular
    case important
}
