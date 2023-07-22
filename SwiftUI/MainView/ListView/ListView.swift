//
//  ListView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct ListView: View {
    @State var items: [ToDoItem]
    @State var selectedItem: ToDoItem?
    @State var isShown: Bool
    @State var presentSheet = false
    
    var body: some View {
        let hideItems = items.filter { $0.completed == false }
        List {
            Section(header: Header(isShown: $isShown, items: items).textCase(.none)) {
                ForEach(isShown ? hideItems : items, id: \.id) { item in
                        Button {
                            selectedItem = item
                            presentSheet.toggle()
                        } label: {
                            TaskRow(item: item)
                                .modifier(LeadingSwipe(completed: item.completed))
                                .modifier(TrailingSwipe(selectedItem: $selectedItem, presentSheet: $presentSheet))
                        }
                        .sheet(item: $selectedItem) { item in
                            DetailsContentView(taskText: item.taskText, presentSheet: $presentSheet, item: item)
                        }
                }
                Button {
                    selectedItem = MockData().emptyItem
                    presentSheet.toggle()
                } label: {
                    NewTaskRow()
                        .sheet(item: $selectedItem) { item in
                            DetailsContentView(taskText: item.taskText, presentSheet: $presentSheet, item: item)
                        }
                        
                }
                
            }
            .listRowSeparatorTint(Color("SupportSeparator"))
            .listRowBackground(Color("BackSecondary"))
        }
        .scrollContentBackground(.hidden)
        .listStyle(.insetGrouped)
        .background(Color("BackPrimary"))
    }
}
