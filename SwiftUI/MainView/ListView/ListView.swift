//
//  ListView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct ListView: View {
    @State var items: [ToDoItem]
    @State var isShown: Bool
    
    var body: some View {
        let hideItems = items.filter { $0.completed == false }
        List {
            Section(header: Header(isShown: $isShown, items: items).textCase(.none)) {
                ForEach(isShown ? hideItems : items, id: \.id) { item in
                    TaskRow(item: item)
                        .modifier(LeadingSwipe(completed: item.completed))
                        .modifier(TrailingSwipe())
                }
                NewTaskRow()
            }
            .listRowSeparatorTint(Color("SupportSeparator"))
            .listRowBackground(Color("BackSecondary"))
        }
        .scrollContentBackground(.hidden)
        .listStyle(.insetGrouped)
        .background(Color("BackPrimary"))
    }
}
