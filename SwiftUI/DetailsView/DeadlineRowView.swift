//
//  DeadlineRowView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct DeadlineRowView: View {
    @Binding var isDeadline: Bool
    @Binding var date: Date
    @Binding var datePickerToShow: Bool
    var item: ToDoItem
    
    let timeStartFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd MMMM yyyy"
        formater.locale = Locale(identifier: "ru_RU")
        return formater
    }()
    
    var body: some View {
        HStack {
            if isDeadline {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Сделать до")
                        .font(.body)
                        .padding(.top, 8)
                        .foregroundColor(Color("LabelPrimary"))
                    Button {
                        withAnimation {
                            datePickerToShow.toggle()
                        }
                    } label: {
                        Text(timeStartFormatter.string(from: date))
                            .font(.footnote)
                            .padding(.bottom, 8)
                    }
                }
                .padding(.horizontal)
                .padding(.leading, 5)
            } else {
                Text("Сделать до")
                    .font(.body)
                    .padding()
                    .padding(.leading, 5)
                    .foregroundColor(Color("LabelPrimary"))
            }
            Spacer()
            Toggle(isOn: $isDeadline) {}
                .padding(.trailing, 20)
        }
        if datePickerToShow && isDeadline {
            VStack(spacing: 0) {
                Divider()
                    .padding(.horizontal, 20)
                DatePicker(
                        "Start Date",
                        selection: $date,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                .datePickerStyle(.graphical)
                .padding(.horizontal, 14)
                .environment(\.locale, Locale(identifier: "ru_RU"))
            }
        }
    }
}
