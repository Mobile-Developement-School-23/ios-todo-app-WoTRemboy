//
//  FileCache.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import Foundation

public final class FileCache {
    public var items: [String: ToDoItem] = [:]
    
    public init() {  }
    
    public func add(item: ToDoItem) -> ToDoItem? {
        let replacedItem = items[item.id]
        items.updateValue(item, forKey: item.id)
        return replacedItem
    }
    
    public func remove(at id: String) -> ToDoItem? {
        if let deletedItem = items[id] {
            items[id] = nil
            return deletedItem
        } else {
            return nil
        }
    }
    
    // MARK: Working with JSON
    
    public func saveToFile(to fileName: String) {
        let jsonItems = items.values.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            try jsonData.write(to: fileURL)
            
        } catch {
            print("Saving to file error: \(error)")
        }
    }
    
    public func loadFromFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).todofile")
            let jsonData = try Data(contentsOf: fileURL)
            let jsonItems = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] ?? []
            let loadedItems = jsonItems.compactMap { ToDoItem.parse(json: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            print("Loading from file error: \(error)")
        }
    }
    
    // MARK: Working with CSV
    
    public func saveToCSVFile(to fileName: String) {
        let csvItems = items.values.map { $0.csv }
        let csvString = csvItems.joined(separator: "\n")
        
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            
        } catch {
            print("Saving to CSV file error: \(error)")
        }
    }
    
    public func loadFromCSVFile(from fileName: String) {
        do {
            guard let filesDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return
            }
            let fileURL = filesDirectory.appendingPathComponent("\(fileName).csv")
            
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvItems = csvString.components(separatedBy: "\n")
            
            let loadedItems = csvItems.compactMap { ToDoItem.parse(csv: $0) }
            items = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
            
        } catch {
            print("Loading from CSV file error: \(error)")
        }
    }
}
