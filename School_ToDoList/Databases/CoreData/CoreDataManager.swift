//
//  CoreDataManager.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 14.07.2023.
//

import Foundation
import CoreData
import FileCachePackage
import CocoaLumberjackSwift
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataBaseModel")
        container.loadPersistentStores(completionHandler: {_, error in
            _ = error.map { fatalError("Persistent container error: \($0)") }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                DDLogError("SaveContext error: \(error)", level: .error)
            }
        }
    }
}

extension ToDoItems {
    func toToDoItem() -> ToDoItem {
        var deadlineCheck: Date? = nil
        if deadline != 0 {
        deadlineCheck = Int(exactly: deadline).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp)) }
        }
        var editDateCheck: Date? = nil
        if editDate != 0 {
        editDateCheck = Int(exactly: editDate).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp)) }
        }

        return ToDoItem(
            id: id ?? "",
            taskText: taskText ?? "",
            importance: Importance(rawValue: importance ?? "") ?? .regular,
            deadline: deadlineCheck,
            completed: (completed != 0),
            createDate: Date(timeIntervalSince1970: TimeInterval(createDate)),
            editDate: editDateCheck
        )
    }
}
