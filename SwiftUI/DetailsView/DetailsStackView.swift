//
//  DetailsStackView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct DetailsStackView: View {
    @Binding var taskText: String
    @Binding var presentSheet: Bool
    @State var importance: Importance
    @State var isDeadline: Bool
    @State var date: Date
    @State var datePickerToShow = false
    
    var item: ToDoItem
    var body: some View {
        VStack(spacing: 0) {
            CustomTextEditor(taskText: $taskText)
            VStack(spacing: 0) {
                ImportanceRowView(selectedImportance: $importance)
                Divider()
                    .padding(.horizontal, 20)
                DeadlineRowView(isDeadline: $isDeadline, date: $date, datePickerToShow: $datePickerToShow, item: item)
            }
            .background(Color("BackSecondary"))
            .cornerRadius(15)
            .padding(.horizontal)
            if taskText.isEmpty {
                DeleteButtonView(presentSheet: $presentSheet, isEnableForOld: false)
            } else {
                DeleteButtonView(presentSheet: $presentSheet, isEnableForOld: true)
            }
            Spacer()

        }
        
    }
}

func isDeadlineHere(deadline: Date?) -> Bool {
    if deadline != nil {
        return true
    } else {
        return false
    }
}
