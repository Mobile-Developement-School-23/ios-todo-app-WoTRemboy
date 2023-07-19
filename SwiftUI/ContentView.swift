//
//  ContentView.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 18.07.2023.
//

import SwiftUI
import FileCachePackage

struct ContentView: View {
    
    var sortedArray: [ToDoItem]
    var body: some View {
        NavigationView {
            ZStack {
                ListView(items: sortedArray)
                FloatingButtonView()
            }
            
            .navigationTitle("Мои дела")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ListView: View {
    @State var items: [ToDoItem]
    
    var body: some View {
        List {
            Section(header: Header().textCase(.none)) {
                ForEach(items, id: \.id) { item in
                    TaskRow(item: item)
                }
                NewTaskRow()
            }
            .listRowBackground(Color("BackSecondary"))
//            .listRowSeparator(.hidden)
        }
    }
}

struct FloatingButtonView: View {
    var body: some View {
        VStack {
            Spacer()
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

func buttonTapped() {
    print("here")
}

struct Header: View {
    var body: some View {
        HStack {
            Text("Выполнено — 1")
                .font(.subheadline)
                .foregroundColor(Color("LabelTertiary"))
            Spacer()
            Button("Показать") {
                buttonTapped()
            }
            .font(.subheadline)
        }
        .padding(.bottom, 8)
    }
}

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

struct MainRowContent: View {
    
    let deadlineEdges = EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
    let noDeadlineEdges = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    
    var item: ToDoItem
    var body: some View {
        HStack(spacing: 5) {
            ImportanceView(importance: item.importance)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.taskText)
                    .font(.body)
                    .foregroundColor(Color("LabelPrimary"))
                    .lineLimit(3)
                    .padding(item.deadline != nil ? deadlineEdges : noDeadlineEdges)

                if item.deadline != nil {
                    DeadlineStack(deadline: item.deadline)
                }
            }
        }
    }
}

struct NewTaskRow: View {
    var body: some View {
        HStack(spacing: 13) {
            Image("doneCircle")
                .hidden()
            Text("Новое")
                .font(.body)
                .foregroundColor(Color("LabelTertiary"))
        }
        .padding(.vertical, 8)
    }
}

struct CompletedView: View {
    var completed: Bool
    var body: some View {
        if completed {
            Image("doneCircle")
                .renderingMode(.original)
        } else {
            Image("emptyCircle")
                .renderingMode(.template)
        }
    }
}

struct TaskRow: View {
    var item: ToDoItem
    var body: some View {
        HStack {
            CompletedView(completed: item.completed)
            VStack(spacing: 10) {
                HStack {
                    MainRowContent(item: item)
                    Spacer()
                    Image("transit")
                }
            }
        }
    }
}

struct DeadlineStack: View {
    var deadline: Date?
    let timeStartFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "dd MMMM"
        formater.locale = Locale(identifier: "ru_RU")
        return formater
    }()
    var body: some View {
        let fromDate = timeStartFormatter.string(from: deadline ?? Date())
        HStack(spacing: 2) {
            Image("miniCalendar")
                .renderingMode(.template)
            Text(fromDate)
                .font(.subheadline)
                .foregroundColor(Color("LabelTertiary"))
        }
        .padding(.bottom, 8)
        
    }
}

final class MokeData {
    let item4 = ToDoItem(taskText: "Here forth", importance: .regular, deadline: .distantFuture, completed: true, createDate: Date(), editDate: Date())
    let item1 = ToDoItem(taskText: "Here first mane many many many many many many many many many many many many many many", importance: .important)
    let item2 = ToDoItem(taskText: "Here second", importance: .regular, deadline: Date())
    let item3 = ToDoItem(taskText: "Here third", importance: .unimportant)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let data = MokeData()
        @State var items = [data.item1, data.item2, data.item3, data.item4]
        ContentView(sortedArray: items)
    }
}
