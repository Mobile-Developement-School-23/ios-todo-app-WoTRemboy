//
//  ContentView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 18.07.2023.
//

import SwiftUI

struct ContentView: View {
    var sortedArray: [ToDoItem]
    var isShown = false
    var body: some View {
        NavigationView {
            ZStack {
                ListView(items: sortedArray, isShown: isShown)
                FloatingButtonView()
            }
            .navigationTitle("Мои дела")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

func buttonTapped() {
    print("here")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let data = MockData()
        @State var items = [data.item1, data.item2, data.item3, data.item4]
        ContentView(sortedArray: items)
    }
}
