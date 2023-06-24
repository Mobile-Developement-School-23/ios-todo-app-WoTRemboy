

import Foundation

final class FileCache {
    private(set) var items: [String: ToDoItem] = [:]
    
    func add(item: ToDoItem) -> ToDoItem? {
        if let replacedItem = items[item.id] { // duplication id check
            items[item.id] = item
            return replacedItem
        } else {
            items[item.id] = item
            return nil
        }
    }
    
    func remove(at id: String) -> ToDoItem? {
        if let deletedItem = items[id] {
            items[id] = nil
            return deletedItem
        } else {
            print("where is no item with this id: \(id)")
            return nil
        }
    }
    
    // MARK: Working with JSON
    
    func saveToFile(to fileName: String) {
        let jsonItems = items.values.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            try jsonData.write(to: fileURL)
            
        } catch {
            print("saving to file error: \(error)")
        }
    }
    
    func loadFromFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            let jsonData = try Data(contentsOf: fileURL)
            let jsonItems = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] ?? []
            let loadedItems = jsonItems.compactMap { ToDoItem.parse(json: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            print("loading from file error: \(error)")
        }
    }
    
    // MARK: Working with CSV
    
    func saveToCSVFile(to fileName: String) {
        let csvItems = items.values.map { $0.csv }
        let csvString = csvItems.joined(separator: "\n")
        
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            print("saving to CSV file error: \(error)")
        }
    }
    
    func loadFromCSVFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvItems = csvString.components(separatedBy: "\n")
            
            let loadedItems = csvItems.compactMap { ToDoItem.parse(csv: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            print("loading from CSV file error: \(error)")
        }
    }
}
