//
//  CustomTextEditor.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct CustomTextEditor: View {
    @State private var text: String = ""
    
    var placeholder: String = "Что надо сделать?"

    var body: some View {
        ZStack(alignment: .leading) {
            UITextViewWrapper(text: $text)
                .cornerRadius(15)
                .frame(height: dynamicHeight(text: text))
                .foregroundColor(.red)
                .padding()
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color("LabelTertiary"))
                    .padding(.leading, 35)
                    .padding(.top, -40)
            }
        }
    }

    private func dynamicHeight(text: String) -> CGFloat {
        let size = CGSize(width: UIScreen.main.bounds.width/1.8, height: .infinity)
        let boundingBox = text.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        return boundingBox.height + 100
    }
}
