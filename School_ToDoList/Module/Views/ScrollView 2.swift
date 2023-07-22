//
//  ScrollView.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

class CustomScrollView: UIScrollView {
    
    lazy var scrollView: CustomScrollView = {
        let scrollView = CustomScrollView()
        scrollView.backgroundColor = UIColor(named: "BackPrimary")
        return scrollView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}
