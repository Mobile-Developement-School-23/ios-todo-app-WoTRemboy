//
//  FloatingButtonView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct FloatingButtonView: View {
    @State var selectedItem: ToDoItem?
    @State var presentSheet = false

    var body: some View {
        VStack {
            Spacer()
            Button {
                selectedItem = MockData().emptyItem
                presentSheet.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 28).bold())
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color("White"))
                    .background(Color("Blue"))
                    .cornerRadius(25)
                    .shadow(radius: 15)
                    .padding(.bottom, 30)
                    .sheet(item: $selectedItem) { item in
                        DetailsContentView(taskText: item.taskText, presentSheet: $presentSheet, item: item)
                    }
            }
            
        }
    }
}
