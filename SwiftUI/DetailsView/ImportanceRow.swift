//
//  ImportanceRow.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct ImportanceRowView: View {
    @Binding var selectedImportance: Int
    var body: some View {
        HStack(spacing: 5) {
            Text("Важность")
                .font(.body)
                .padding()
                .padding(.leading, 5)
            Spacer()
            Picker("Importance", selection: $selectedImportance) {
                            Image("unimportant").tag(0)
                            Text("нет").tag(1)
                            Image("important").tag(2)
                        }
            .pickerStyle(.segmented)
            .frame(width: 150)
            .padding(.trailing, 20)
        }
    }
}
