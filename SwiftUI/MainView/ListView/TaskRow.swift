//
//  TaskRow.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct TaskRow: View {
    var item: ToDoItem
    var body: some View {
        HStack {
            CompletedCircleView(completed: item.completed, importance: item.importance)
            VStack(spacing: 10) {
                HStack {
                    MainRowContent(item: item)
                    Spacer()
                    Image("transit")
                }
            }
        }
    }
}
