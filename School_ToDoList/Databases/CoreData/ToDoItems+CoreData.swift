//
//  ToDoItems+CoreData.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 14.07.2023.
//
//

import Foundation
import CoreData

@objc(ToDoItems)
public class ToDoItems: NSManagedObject {}

extension ToDoItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItems> {
        return NSFetchRequest<ToDoItems>(entityName: "ToDoItems")
    }

    @NSManaged public var id: String?
    @NSManaged public var taskText: String?
    @NSManaged public var importance: String?
    @NSManaged public var deadline: Int64
    @NSManaged public var completed: Int16
    @NSManaged public var createDate: Int64
    @NSManaged public var editDate: Int64

}

extension ToDoItems: Identifiable {}
