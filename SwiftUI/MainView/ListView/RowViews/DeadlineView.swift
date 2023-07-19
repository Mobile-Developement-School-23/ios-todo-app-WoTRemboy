//
//  DeadlineView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct DeadlineView: View {
    var deadline: Date?
    let timeStartFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd MMMM"
        formater.locale = Locale(identifier: "ru_RU")
        return formater
    }()
    var body: some View {
        let fromDate = timeStartFormatter.string(from: deadline ?? Date())
        HStack(spacing: 2) {
            Image("miniCalendar")
                .renderingMode(.template)
            Text(fromDate)
                .font(.subheadline)
                .foregroundColor(Color("LabelTertiary"))
        }
        .padding(.bottom, 8)
        
    }
}
