//
//  MockData.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import Foundation

final class MockData {
    let item4 = ToDoItem(taskText: "Here forth", importance: .regular, deadline: .distantFuture, completed: true, createDate: Date(), editDate: Date())
    let item1 = ToDoItem(taskText: "Here first mane many many many many many many many many many many many many many many", importance: .important)
    let item2 = ToDoItem(taskText: "Here second", importance: .regular, deadline: Date(), completed: true)
    let item3 = ToDoItem(taskText: "Here third", importance: .unimportant)
}
