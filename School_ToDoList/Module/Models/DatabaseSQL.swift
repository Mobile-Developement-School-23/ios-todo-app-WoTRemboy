//
//  WorkingWithDB.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 12.07.2023.
//

import Foundation
import FileCachePackage
import CocoaLumberjackSwift
import SQLite

public final class FileCacheSQL {
    private(set) var items: [String: ToDoItem] = [:]
    private var database: Connection?
    
    let toDoItems = Table("ToDoItems")
    
    let id = Expression<String>("id")
    let taskText = Expression<String>("taskText")
    let importance = Expression<Importance.RawValue>("importance")
    let deadline = Expression<Int?>("deadline")
    let completed = Expression<Bool>("completed")
    let createDate = Expression<Int>("createDate")
    let editDate = Expression<Int?>("editDate")
    
    init() {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return
            }
            let databaseURL = filesDirectory.appendingPathComponent("fileCache.db")
            database = try Connection(databaseURL.path)
            
            createTableSQLIfNeeded()
            loadFromDatabaseSQL()
            
        } catch {
            DDLogError("Database initialization error: \(error)", level: .error)
        }
    }
    
    func createTableSQLIfNeeded() {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error")
                return
            }
            
            let createTable = toDoItems.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(taskText)
                table.column(importance)
                table.column(deadline)
                table.column(completed)
                table.column(createDate)
                table.column(editDate)
            }
            try database.run(createTable)
        } catch {
            DDLogError("Creating SQL table error: \(error)", level: .error)
        }
    }
    
    func saveToDatabaseSQL(items: [ToDoItem]) {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error")
                return
            }
            
            var sqlReplaceStatement = ""
            
            for item in items {
                var deadline: Int?
                if let deadlineCheck = item.deadline?.timeIntervalSince1970 {
                    deadline = Int(deadlineCheck)
                }
                let createDate = Int(item.createDate.timeIntervalSince1970)
                var editDate: Int?
                if let editDateCheck = item.editDate?.timeIntervalSince1970 {
                    editDate = Int(editDateCheck)
                }
                let replaceStatement = """
                            REPLACE INTO toDoItems
                            (id, taskText, importance, deadline, completed, createDate, editDate)
                            VALUES
                            ('\(item.id)', '\(item.taskText)', '\(item.importance.rawValue)', \(deadline != nil ? "'\(deadline ?? 0)'" : "NULL"), \(item.completed), '\(createDate)', \(editDate != nil ? "'\(editDate ?? 0)'" : "NULL"));
                            """
                sqlReplaceStatement.append(replaceStatement)
            }
            try database.execute(sqlReplaceStatement)
            
            let localItemIDs = items.map { $0.id }
            let databaseItemIDs = try database.prepare(toDoItems.select(id)).map { $0[id] }
            let deletedItemIDs = Set(databaseItemIDs).subtracting(localItemIDs)
            
            if !deletedItemIDs.isEmpty {
                let deleteQuery = toDoItems.filter(deletedItemIDs.contains(id))
                try database.run(deleteQuery.delete())
            }
            
//            try database.run(toDoItems.delete())
            
//            for item in items {
//                let insert = toDoItems.insert(
//                    id <- item.id,
//                    taskText <- item.taskText,
//                    importance <- item.importance.rawValue,
//                    deadline <- item.deadline,
//                    completed <- item.completed,
//                    createDate <- item.createDate,
//                    editDate <- item.editDate
//                )
//                let replace = insert
//                try database.run(insert)
//            }
            DDLogDebug("Saved to database SQL", level: .debug)

        } catch {
            DDLogError("Saving to database SQL error: \(error)", level: .error)
        }
    }
    
    func loadFromDatabaseSQL() {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error")
                return
            }
            let query = toDoItems.order(createDate)
            let loadedItems = try database.prepare(query).map { row -> ToDoItem in
                let item = ToDoItem(
                    id: row[id],
                    taskText: row[taskText],
                    importance: Importance(rawValue: row[importance]) ?? .regular,
                    deadline: row[deadline].flatMap { timestamp -> Date? in
                        return Date(timeIntervalSince1970: TimeInterval(timestamp)) },
                    completed: row[completed],
                    createDate: Date(timeIntervalSince1970: TimeInterval(row[createDate])),
                    editDate: row[editDate].flatMap { timestamp -> Date? in
                        return Date(timeIntervalSince1970: TimeInterval(timestamp)) })
                return item
            }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
        } catch {
            DDLogError("Loading items from database SQL error: \(error)")
        }
    }

}
