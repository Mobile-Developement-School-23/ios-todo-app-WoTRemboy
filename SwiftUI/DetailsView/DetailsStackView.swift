//
//  DetailsStackView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct DetailsStackView: View {
    @Binding var taskText: String
    @State var selectedImportance = 1
    @State var isDeadline = false
    @State var date = Date()
    @State var datePickerToShow = false
    
    var item: ToDoItem
    var body: some View {
        VStack(spacing: 0) {
            CustomTextEditor()
            VStack(spacing: 0) {
                ImportanceRowView(selectedImportance: $selectedImportance)
                Divider()
                    .padding(.horizontal, 20)
                DeadlineRowView(isDeadline: $isDeadline, date: $date, datePickerToShow: $datePickerToShow)
            }
            .background(Color("BackSecondary"))
            .cornerRadius(15)
            .padding(.horizontal)
            DeleteButtonView()
            Spacer()

        }
        
    }
}
