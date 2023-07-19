//
//  SharingJSON.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 06.07.2023.
//

import Foundation
import FileCachePackage
import UIKit

extension ToDoItem {
    public static func sharingParse(sharingJSON: Any) -> ToDoItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let taskText = data["text"] as? String,
              let createDateInt = data["created_at"] as? Int
        else {
            return nil
        }
        
        let createDate = Date(timeIntervalSince1970: TimeInterval(createDateInt))
        let completed = data["done"] as? Bool
        let importanceR = data["importance"] as? String
        var importance = Importance.regular
        switch importanceR {
        case "low":
            importance = Importance.unimportant
        case "basic":
            importance = Importance.regular
        case "important":
            importance = Importance.important
        default:
            importance = Importance.regular
        }
        let deadline = (data["deadline"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        var editDate = (data["changed_at"] as? Int).flatMap { timestamp -> Date? in
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        if editDate == createDate {
            editDate = nil
        }

        return ToDoItem(id: id,
                        taskText: taskText,
                        importance: importance,
                        deadline: deadline,
                        completed: completed ?? false,
                        createDate: createDate,
                        editDate: editDate)
    }
    
    public var sharingJSON: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": taskText,
            "done": completed
        ]
        
        switch importance {
        case .unimportant:
            dictionary["importance"] = "low"
        case .regular:
            dictionary["importance"] = "basic"
        case .important:
            dictionary["importance"] = "important"
        }

        if let deadline = deadline {
            dictionary["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        dictionary["created_at"] = Int(createDate.timeIntervalSince1970)
        
        dictionary["changed_at"] = Int(editDate?.timeIntervalSince1970 ?? createDate.timeIntervalSince1970) // the API description does not say what may be missing
        
        let device = UIDevice.current
        let deviceID = device.identifierForVendor?.uuidString
        dictionary["last_updated_by"] = deviceID
        
        let sharingDictionary: [String: Any] = [
            "status": "ok",
            "element": dictionary
        ]
        
        return sharingDictionary
    }
}
