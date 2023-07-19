//
//  SwipesModifiers.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct LeadingSwipe: ViewModifier {
    var completed: Bool
    let doneImage = Image(systemName: "arrow.uturn.down")
    let notDoneImage = Image(systemName: "checkmark.circle")
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading) {
                Button {
                    buttonTapped()
                } label: {
                    completed ? doneImage : notDoneImage
                }
                .tint(completed ? Color("GrayLight") : Color("Green"))
            }
    }
}

struct TrailingSwipe: ViewModifier {
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    buttonTapped()
                } label: {
                    Image(systemName: "trash.fill")
                }
                Button {
                    buttonTapped()
                } label: {
                    Image(systemName: "info.circle")
                }
                .tint(Color("GrayLight"))
            }
    }
}
