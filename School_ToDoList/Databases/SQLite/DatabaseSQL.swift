//
//  WorkingWithDB.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 12.07.2023.
//

import Foundation
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
                DDLogError("Documents directory not found", level: .error)
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
                DDLogError("Database connection error", level: .error)
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
                DDLogError("Database connection error", level: .error)
                return
            }
            
            var sqlReplaceStatement = ""
            let request = "REPLACE INTO"
            let table = "toDoItems"
            let toDoItemModel = "(id, taskText, importance, deadline, completed, createDate, editDate)"
            
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
                            \(request) \(table)
                            \(toDoItemModel)
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
            DDLogDebug("Saved to database SQL", level: .debug)

        } catch {
            DDLogError("Saving to database SQL error: \(error)", level: .error)
        }
    }
    
    func loadFromDatabaseSQL() {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error", level: .error)
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
    
    func deleteFromDatabaseSQL(at itemID: String) {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error", level: .error)
                return
            }
            
            let deleteQuery = toDoItems.filter(id == itemID)
            try database.run(deleteQuery.delete())
            
            DDLogDebug("Deleted from database SQL", level: .debug)
        } catch {
            DDLogError("Deleting from database SQL error: \(error)", level: .error)
        }
    }

    func insertToDatabaseSQL(item: ToDoItem) {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error", level: .error)
                return
            }
            
            var itemDeadline: Int?
            if let deadlineCheck = item.deadline?.timeIntervalSince1970 {
                itemDeadline = Int(deadlineCheck)
            }
            let itemCreateDate = Int(item.createDate.timeIntervalSince1970)
            var itemEditDate: Int?
            if let editDateCheck = item.editDate?.timeIntervalSince1970 {
                itemEditDate = Int(editDateCheck)
            }
            
            try database.run(toDoItems.insert(
                id <- item.id,
                taskText <- item.taskText,
                importance <- item.importance.rawValue,
                deadline <- itemDeadline,
                completed <- item.completed,
                createDate <- itemCreateDate,
                editDate <- itemEditDate
            ))
            
            DDLogDebug("Inserted into database SQL", level: .debug)
        } catch {
            DDLogError("Inserting into database SQL error: \(error)", level: .error)
        }
    }

    func updateInDatabaseSQL(item: ToDoItem) {
        do {
            guard let database = self.database else {
                DDLogError("Database connection error")
                return
            }
            
            var itemDeadline: Int?
            if let deadlineCheck = item.deadline?.timeIntervalSince1970 {
                itemDeadline = Int(deadlineCheck)
            }
            var itemEditDate: Int?
            if let editDateCheck = item.editDate?.timeIntervalSince1970 {
                itemEditDate = Int(editDateCheck)
            }
            
            let update = toDoItems.filter(id == item.id)
            try database.run(update.update(
                taskText <- item.taskText,
                importance <- item.importance.rawValue,
                deadline <- itemDeadline,
                completed <- item.completed,
                editDate <- itemEditDate
            ))
            
            DDLogDebug("Updated in database SQL", level: .debug)
        } catch {
            DDLogError("Updating in database SQL error: \(error)", level: .error)
        }
    }

}
