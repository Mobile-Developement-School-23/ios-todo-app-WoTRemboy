//
//  FloatingButtonView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct FloatingButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            Button {
                buttonTapped()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 28).bold())
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color("White"))
                    .background(Color("Blue"))
                    .cornerRadius(25)
                    .shadow(radius: 15)
                    .padding(.bottom, 30)
            }
            
        }
    }
}
