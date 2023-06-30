

import Foundation
import CocoaLumberjackSwift

final class FileCache {
    private(set) var items: [String: ToDoItem] = [:]
    
    func add(item: ToDoItem) -> ToDoItem? {
        let replacedItem = items[item.id]
        items.updateValue(item, forKey: item.id)
        DDLogDebug("Item added to fileCache", level: .debug)
        return replacedItem
    }
    
    func remove(at id: String) -> ToDoItem? {
        if let deletedItem = items[id] {
            items[id] = nil
            DDLogDebug("Item deleted from fileCache", level: .debug)
            return deletedItem
        } else {
            DDLogError("Where is no item with this id: \(id)", level: .error)
            return nil
        }
    }
    
    // MARK: Working with JSON
    
    func saveToFile(to fileName: String) {
        let jsonItems = items.values.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DDLogError("Documents directory not found", level: .error)
                return
            }
            DDLogDebug("Files directory configurated", level: .debug)
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            try jsonData.write(to: fileURL)
            
        } catch {
            DDLogError("Saving to file error: \(error)", level: .error)
        }
        DDLogDebug("Saved fileCache", level: .debug)
        DDLogInfo("All tasks: \(items.count); Completed: \(items.values.filter { $0.completed }.count)", level: .info)
    }
    
    func loadFromFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DDLogError("Documents directory not found", level: .error)
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            let jsonData = try Data(contentsOf: fileURL)
            let jsonItems = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] ?? []
            let loadedItems = jsonItems.compactMap { ToDoItem.parse(json: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            DDLogError("Loading from file error: \(error)", level: .error)
        }
    }
    
    // MARK: Working with CSV
    
    func saveToCSVFile(to fileName: String) {
        let csvItems = items.values.map { $0.csv }
        let csvString = csvItems.joined(separator: "\n")
        
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DDLogError("Documents directory not found", level: .error)
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            DDLogError("Saving to CSV file error: \(error)", level: .error)
        }
    }
    
    func loadFromCSVFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DDLogError("Documents directory not found", level: .error)
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvItems = csvString.components(separatedBy: "\n")
            
            let loadedItems = csvItems.compactMap { ToDoItem.parse(csv: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            DDLogError("Loading from CSV file error: \(error)", level: .error)
        }
    }
}
