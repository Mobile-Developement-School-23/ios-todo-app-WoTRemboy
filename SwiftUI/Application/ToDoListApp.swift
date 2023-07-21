//
//  ToDoListApp.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 18.07.2023.
//

import SwiftUI

let fileCacheSQL = FileCacheSQL()

@main
struct ToDoListApp: App {
    var body: some Scene {
        let values = Array(fileCacheSQL.items.values)
        let sortedValues = values.sorted { $0.createDate > $1.createDate }
        let sortedArray = sortedValues.map { $0 }
        
        WindowGroup {
//            DetailsContentView(taskText: sortedArray.first!.taskText, item: sortedArray.first!)
            MainContentView(sortedArray: sortedArray)
        }
    }
}
