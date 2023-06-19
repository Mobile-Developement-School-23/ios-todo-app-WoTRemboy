

import XCTest

@testable import School_ToDoList

final class ConfigurationAndParsingTests: XCTestCase {
    
    
    // MARK: Parsing tests with ToDoItem struct features
    
    func testJSONParseMinimum() throws {
        let item = ToDoItem(taskText: "jsonItem1",
                            importance: .regular)
        jsonParseAndEqualMethod(item: item)
    }
    
    func testJSONParseDates() throws {
        let item = ToDoItem(taskText: "jsonItem2",
                            importance: .unimportant,
                            deadline: Date(timeIntervalSince1970: 3920000),
                            createDate: Date(),
                            editDate: Date(timeIntervalSince1970: 1999999))
        jsonParseAndEqualMethod(item: item)
    }
    
    func testJSONParseCompetedAndID() throws {
        let item = ToDoItem(id: "12345",
                            taskText: "jsonItem3",
                            importance: .regular,
                            completed: true)
        jsonParseAndEqualMethod(item: item)
    }
    
    func testJSONParseMaximum() throws {
        let item = ToDoItem(id: "123",
                            taskText: "jsonItem4",
                            importance: .important,
                            deadline: Date(timeIntervalSince1970: 73000034),
                            completed: true,
                            editDate: Date(timeIntervalSince1970: 73000021))
        jsonParseAndEqualMethod(item: item)
    }
    
    func testCSVParseMinimum() throws {
        let item = ToDoItem(taskText: "csvItem1",
                            importance: .regular)
        csvParseAndEqualMethod(item: item)
    }
    
    func testCSVParseDates() throws {
        let item = ToDoItem(taskText: "csvItem2",
                            importance: .unimportant,
                            deadline: Date(timeIntervalSince1970: 3920000),
                            createDate: Date(),
                            editDate: Date(timeIntervalSince1970: 1999999))
        csvParseAndEqualMethod(item: item)
    }
    
    func testCSVParseCompetedAndID() throws {
        let item = ToDoItem(id: "12345",
                            taskText: "csvItem3",
                            importance: .regular,
                            completed: true)
        csvParseAndEqualMethod(item: item)
    }
    
    func testCSVParseMaximum() throws {
        let item = ToDoItem(id: "123",
                            taskText: "csvItem4",
                            importance: .important,
                            deadline: Date(timeIntervalSince1970: 73000034),
                            completed: true, editDate: Date(timeIntervalSince1970: 73000021))
        csvParseAndEqualMethod(item: item)
    }
    
    // MARK: Data configuration tests with ToDoItem struct features
    
    func testJSONDataConfigEmptyFields() throws {
        let item = ToDoItem(taskText: "jsonItem1",
                            importance: .regular,
                            createDate: Date(timeIntervalSince1970: 18888888))
        let standartJSON: [String: Any] = [
            "id": "\(item.id)",
            "taskText": "\(item.taskText)",
            "completed": item.completed,
            "createDate": Int(item.createDate.timeIntervalSince1970)
        ]
        let parsedItem = ToDoItem.parse(json: standartJSON)
        XCTAssert(parsedItem != nil, "JSON parse's been broken")
        equalMethod(givenItem: item, parsedItem: parsedItem!)
    }
    
    func testJSONDataConfigMaximum() throws {
        let item = ToDoItem(id: "123",
                             taskText: "csvItem2",
                             importance: .important,
                             deadline: Date(timeIntervalSince1970: 73000034),
                             completed: true,
                             createDate: Date(timeIntervalSince1970: 73000014),
                             editDate: Date(timeIntervalSince1970: 73000021))
        let standartJSON: [String: Any] = [
            "id": "\(item.id)",
            "taskText": "\(item.taskText)",
            "importance": "\(item.importance)",
            "deadline": Int(item.deadline!.timeIntervalSince1970),
            "completed": item.completed,
            "createDate": Int(item.createDate.timeIntervalSince1970),
            "editDate": Int(item.editDate!.timeIntervalSince1970)
        ]
        let parsedItem = ToDoItem.parse(json: standartJSON)
        XCTAssert(parsedItem != nil, "JSON parse's been broken")
        equalMethod(givenItem: item, parsedItem: parsedItem!)
    }
    
    func testCSVDataConfigEmptyFields() throws {
        let item = ToDoItem(taskText: "csvItem2",
                            importance: .regular,
                            createDate: Date(timeIntervalSince1970: 2999999))
        let csv = item.csv
        let standart = "\(item.id);\(item.taskText);;;\(item.completed);\(Int(item.createDate.timeIntervalSince1970));"
        XCTAssert(csv == standart, "csv configuration's been broken")
    }
    
    func testCSVDataConfigMaximum() throws {
        let item = ToDoItem(id: "123",
                             taskText: "csvItem2",
                             importance: .important,
                             deadline: Date(timeIntervalSince1970: 73000034),
                             completed: true,
                             editDate: Date(timeIntervalSince1970: 73000021))
        let csv = item.csv
        let standart = "\(item.id);\(item.taskText);\(item.importance);\(Int(item.deadline!.timeIntervalSince1970));\(item.completed);\(Int(item.createDate.timeIntervalSince1970));\(Int(item.editDate!.timeIntervalSince1970))"
        XCTAssert(csv == standart, "csv configuration's been broken")
    }
    
    // MARK: JSONSerialization tests
    
    func testJSONSerializationMinimum() throws {
        let item = ToDoItem(taskText: "jsonitem1",
                            importance: .regular)
        let items = ["\(item.id)": item]
        let jsonItems = items.values.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
        let returnedJSONItems = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any]
        XCTAssert(returnedJSONItems != nil, "jsonObject configuration's been broken")
        let loadedItem = ToDoItem.parse(json: returnedJSONItems!.first!)
        XCTAssert(loadedItem != nil, "JSON parse's been broken")
        equalMethod(givenItem: item, parsedItem: loadedItem!)
    }
    
    func testJSONSerializationMaximum() throws {
        let item1 = ToDoItem(taskText: "jsonItem1",
                            importance: .unimportant,
                            deadline: Date(timeIntervalSince1970: 3920000),
                            createDate: Date(),
                            editDate: Date(timeIntervalSince1970: 1999999))
        let item2 = ToDoItem(id: "12345",
                             taskText: "jsonItem2",
                             importance: .regular,
                             completed: true)
        let item3 = ToDoItem(id: "123",
                             taskText: "jsonItem3",
                             importance: .important,
                             deadline: Date(timeIntervalSince1970: 73000034),
                             completed: true,
                             editDate: Date(timeIntervalSince1970: 73000021))
        let items = ["\(item1.id)": item1, "\(item2.id)": item2, "\(item3.id)": item3]
        let jsonItems = items.values.map { $0.json }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonItems, options: [])
        let returnedJSONItems = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] ?? []
        XCTAssert(!returnedJSONItems.isEmpty, "jsonObject configuration's been broken")
        let loadedItems = returnedJSONItems.compactMap { ToDoItem.parse(json: $0) }
        let parsedItems = Dictionary(uniqueKeysWithValues: loadedItems.map { ($0.id, $0) })
        equalMethod(givenItem: item1, parsedItem: parsedItems["\(item1.id)"]!)
        equalMethod(givenItem: item2, parsedItem: parsedItems["\(item2.id)"]!)
        equalMethod(givenItem: item3, parsedItem: parsedItems["\(item3.id)"]!)
    }
    
    // MARK: Test methods
    
    private func jsonParseAndEqualMethod(item givenItem: ToDoItem) {
        let json = givenItem.json
        let parsedItem = ToDoItem.parse(json: json)
        XCTAssert(parsedItem != nil, "JSON parse's been broken")
        equalMethod(givenItem: givenItem, parsedItem: parsedItem!)
    }
    
    private func csvParseAndEqualMethod(item givenItem: ToDoItem) {
        let csv = givenItem.csv
        let parsedItem = ToDoItem.parse(csv: csv)
        XCTAssert(parsedItem != nil, "csv parse's been broken")
        equalMethod(givenItem: givenItem, parsedItem: parsedItem!)
    }
    
    private func equalMethod(givenItem: ToDoItem, parsedItem: ToDoItem) {
        let tolerance: TimeInterval = 1 // to avoid ±1 second Date() error

        XCTAssert(givenItem.id == parsedItem.id, "ID's been damaged during parsing: \(givenItem.id) to \(parsedItem.id)")
        XCTAssert(givenItem.taskText == parsedItem.taskText, "Task text's been damaged during parsing: \(givenItem.taskText) to \(parsedItem.taskText)")
        XCTAssert(givenItem.importance == parsedItem.importance, "Importance's been damaged during parsing: \(givenItem.importance) to \(parsedItem.importance)")
        
        if let deadline = givenItem.deadline {
            XCTAssert(deadline.compare(parsedItem.deadline!) == .orderedSame, "Deadline date's been damaged during parsing: \(deadline) to \(parsedItem.deadline!)")
        }
        XCTAssert(givenItem.completed == parsedItem.completed, "Completed's been damaged during parsing: \(givenItem.completed) to \(parsedItem.completed)")
        XCTAssert(abs(givenItem.createDate.timeIntervalSince1970 - parsedItem.createDate.timeIntervalSince1970) < tolerance, "Create date's been damaged during parsing: \(givenItem.createDate) to \(parsedItem.createDate)")
        
        if let editDate = givenItem.editDate {
            XCTAssert(editDate.compare(parsedItem.editDate!) == .orderedSame, "Edit date's been damaged during parsing: \(editDate) to \(parsedItem.editDate!)")
        }
    }
    
}
