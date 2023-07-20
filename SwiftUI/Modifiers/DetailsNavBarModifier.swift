//
//  DetailsNavBarModifier.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 20.07.2023.
//

import SwiftUI

struct DetailsNavBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button {
                buttonTapped()
            } label: {
                Text("Отменить")
            })
            .navigationBarItems(trailing: Button {
                buttonTapped()
            } label: {
                Text("Сохранить")
            })
    }
}
