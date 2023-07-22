//
//  NewTaskRow.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct NewTaskRow: View {
    var body: some View {
        HStack(spacing: 13) {
            Image("doneCircle")
                .hidden()
            Text("Новое")
                .font(.body)
                .foregroundColor(Color("LabelTertiary"))
        }
        .padding(.vertical, 8)
    }
}
