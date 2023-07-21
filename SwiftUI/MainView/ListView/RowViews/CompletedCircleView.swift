//
//  CompletedCircleView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 19.07.2023.
//

import SwiftUI

struct CompletedCircleView: View {
    var completed: Bool
    var importance: Importance
    var body: some View {
        if completed {
            Image("doneCircle")
                .renderingMode(.original)
        } else if importance == .important {
            Image("importantCircle")
                .renderingMode(.original)
        } else {
            Image("emptyCircle")
                .renderingMode(.template)
                .foregroundColor(Color("LabelTertiary"))
        }
    }
}
