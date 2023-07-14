//
//  DatabaseCD.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 14.07.2023.
//

import Foundation
import CoreData
import FileCachePackage
import CocoaLumberjackSwift

public final class FileCacheCoreData {
    private(set) var items: [String: ToDoItem] = [:]
    
    init() {
        loadFromDatabaseCoreData()
    }

    func saveToDatabaseCoreData(items: [ToDoItem]) {
        let context = CoreDataManager.shared.backgroundContext()
        
        context.perform {
            let existingItems = self.fetchAllItems(in: context)
            
            for existingItem in existingItems {
                if let matchingItem = items.first(where: { $0.id == existingItem.id }) {
                    self.updateExistingItem(existingItem, with: matchingItem)
                } else {
                    context.delete(existingItem)
                }
            }
            
            for newItem in items {
                if !existingItems.contains(where: { $0.id == newItem.id }) {
                    _ = self.createCoreDataItem(from: newItem, in: context)
                }
            }
            
            do {
                try context.save()
                DDLogDebug("Saved to database CoreData", level: .debug)
                self.loadFromDatabaseCoreData()
            } catch {
                DDLogError("Saving to database error: \(error)", level: .error)
            }
        }
    }

    func fetchAllItems(in context: NSManagedObjectContext) -> [ToDoItems] {
        let fetchRequest: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            DDLogError("Error fetching items from database: \(error)", level: .error)
            return []
        }
    }

    func fetchItem(withID id: String, in context: NSManagedObjectContext) -> ToDoItems? {
        let fetchRequest: NSFetchRequest<ToDoItems> = ToDoItems.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            DDLogError("Error fetching item from database: \(error)", level: .error)
            return nil
        }
    }

    func updateExistingItem(_ existingItem: ToDoItems, with newItem: ToDoItem) {
        var deadline: Int?
        if let deadlineCheck = newItem.deadline?.timeIntervalSince1970 {
            deadline = Int(deadlineCheck)
        }
        let createDate = Int(newItem.createDate.timeIntervalSince1970)
        var editDate: Int?
        if let editDateCheck = newItem.editDate?.timeIntervalSince1970 {
            editDate = Int(editDateCheck)
        }
        existingItem.taskText = newItem.taskText
        existingItem.importance = newItem.importance.rawValue
        existingItem.deadline = Int64(deadline ?? 0)
        existingItem.completed = Int16(newItem.completed ? 1 : 0)
        existingItem.createDate = Int64(createDate)
        existingItem.editDate = Int64(editDate ?? 0)
    }

    func createCoreDataItem(from item: ToDoItem, in context: NSManagedObjectContext) -> ToDoItems {
        var deadline: Int?
        if let deadlineCheck = item.deadline?.timeIntervalSince1970 {
            deadline = Int(deadlineCheck)
        }
        let createDate = Int(item.createDate.timeIntervalSince1970)
        var editDate: Int?
        if let editDateCheck = item.editDate?.timeIntervalSince1970 {
            editDate = Int(editDateCheck)
        }
        let coreDataItem = ToDoItems(context: context)
        coreDataItem.id = item.id
        coreDataItem.taskText = item.taskText
        coreDataItem.importance = item.importance.rawValue
        coreDataItem.deadline = Int64(deadline ?? 0)
        coreDataItem.completed = Int16(item.completed ? 1 : 0)
        coreDataItem.createDate = Int64(createDate)
        coreDataItem.editDate = Int64(editDate ?? 0)
        return coreDataItem
    }

    func loadFromDatabaseCoreData() {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<ToDoItems> = NSFetchRequest(entityName: "ToDoItems")
        
        do {
            let coreDataItems = try context.fetch(fetchRequest)
            items = Dictionary(uniqueKeysWithValues: coreDataItems.map { ($0.id ?? "", $0.toToDoItem()) })
        } catch {
            DDLogError("Loading items from database error: \(error)", level: .error)
        }
    }
}
