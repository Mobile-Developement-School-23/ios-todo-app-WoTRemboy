//
//  MainRowContent.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct MainRowContent: View {
    
    let deadlineEdges = EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
    let noDeadlineEdges = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    
    var item: ToDoItem
    var body: some View {
        HStack(spacing: 0) {
            Text("") // kostyl' to fix separator width
                .foregroundColor(Color.clear)
            HStack(spacing: 5) {
                ImportanceView(importance: item.importance)
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.taskText)
                        .font(.body)
                        .foregroundColor(item.completed ? Color("LabelTertiary") : Color("LabelPrimary"))
                        .lineLimit(3)
                        .padding(item.deadline != nil ? deadlineEdges : noDeadlineEdges)
                        .strikethrough(item.completed ? true : false)

                    if item.deadline != nil {
                        DeadlineView(deadline: item.deadline)
                    }
                }
            }
            
        }
    }
}
