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
    var item: ToDoItem
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackPrimary")
                    .ignoresSafeArea()
                DetailsStackView(taskText: $taskText, item: item)
            }
            .modifier(DetailsNavBarModifier())
        }
        
    }
}

struct DetailsContentViewPreviews: PreviewProvider {
    static var previews: some View {
        let data = MockData()
        @State var item = data.item4
        DetailsContentView(taskText: item.taskText, item: item)
    }
}
