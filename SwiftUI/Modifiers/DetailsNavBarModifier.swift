//
//  DetailsNavBarModifier.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 20.07.2023.
//

import SwiftUI

struct DetailsNavBarModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var isSaveDisabled: Bool
    func body(content: Content) -> some View {
        content
            .navigationTitle("Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button {
                dismiss()
            } label: {
                Text("Cancel")
            })
            .navigationBarItems(trailing: Button {
                dismiss()
            } label: {
                Text("Save")
            }
                .disabled(isSaveDisabled)
            )
    }
}
