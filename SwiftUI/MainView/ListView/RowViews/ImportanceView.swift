//
//  ImportanceView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct ImportanceView: View {
    var importance: Importance
    var body: some View {
        switch importance {
        case .unimportant:
            Image("unimportantCell")
        case .regular:
            Image(uiImage: UIImage())
                .background(Color.clear)
        case .important:
            Image("importantCell")
        }
    }
}
