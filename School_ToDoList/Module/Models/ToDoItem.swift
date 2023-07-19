//
//  ToDoItem.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import Foundation

public struct ToDoItem: Identifiable {
    public let id: String
    public let taskText: String
    public let importance: Importance
    public let deadline: Date?
    public let completed: Bool
    public let createDate: Date
    public let editDate: Date?
    
    // MARK: Initializer considering default values ​​for properties and field values
    
    public init(id: String = UUID().uuidString, taskText: String, importance: Importance, deadline: Date? = nil, completed: Bool = false, createDate: Date = Date(), editDate: Date? = nil) {
        self.id = id
        self.taskText = taskText
        self.importance = importance
        self.deadline = deadline
        self.completed = completed
        self.createDate = createDate
        self.editDate = editDate
    }

}

public enum Importance: String {
    case unimportant
    case regular
    case important
}
