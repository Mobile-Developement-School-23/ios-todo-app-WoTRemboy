//
//  ImportanceRow.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct ImportanceRowView: View {
    @Binding var selectedImportance: Importance
    var body: some View {
        HStack(spacing: 5) {
            Text("Importance")
                .font(.body)
                .padding()
                .padding(.leading, 5)
                .foregroundColor(Color("LabelPrimary"))
            Spacer()
            Picker("Importance", selection: $selectedImportance) {
                Image("unimportant").tag(Importance.unimportant)
                Text("no").tag(Importance.regular)
                Image("important").tag(Importance.important)
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
            .padding(.trailing, 20)
        }
    }
}
