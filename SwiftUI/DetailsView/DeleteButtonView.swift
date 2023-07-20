//
//  DeleteButtonView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI

struct DeleteButtonView: View {
    var body: some View {
        GeometryReader { geometry in
            Button {
                buttonTapped()
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.915, height: 56)
                        .foregroundColor(Color("BackSecondary"))
                        .cornerRadius(15)
                        .padding()
                    Text("Удалить")
                        .foregroundColor(Color("Red"))
                        .padding(.vertical)
                }
            }
        }
    }
}
