//
//  DetailsContentView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 20.07.2023.
//

import SwiftUI
import UIKit

struct DetailsContentView: View {
    @State var taskText: String
    @Binding var presentSheet: Bool
    var item: ToDoItem
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackPrimary")
                    .ignoresSafeArea()
                DetailsStackView(taskText: $taskText, presentSheet: $presentSheet, importance: item.importance, isDeadline: isDeadlineHere(deadline: item.deadline), date: item.deadline ?? Date(), item: item)
            }
            .modifier(DetailsNavBarModifier(isSaveDisabled: item.taskText.isEmpty))
        }
        
    }
}

struct DetailsContentViewPreviews: PreviewProvider {
    static var previews: some View {
        let data = MockData()
        @State var item = data.item4
        @State var present = false
        DetailsContentView(taskText: item.taskText, presentSheet: $present, item: item)
    }
}
