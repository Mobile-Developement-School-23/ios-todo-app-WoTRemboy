//
//  HeaderView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct Header: View {
    @Binding var isShown: Bool
    var items: [ToDoItem]
    var body: some View {
        let completedCount = items.filter { $0.completed }.count
        HStack {
            Text("Выполнено — \(completedCount)")
                .font(.subheadline)
                .foregroundColor(Color("LabelTertiary"))
            Spacer()
            Button(isShown ? "Показать" : "Скрыть") {
                withAnimation {
                    self.isShown.toggle()
                }
            }
            .font(.subheadline)
        }
        .padding(.bottom, 8)
    }
}
