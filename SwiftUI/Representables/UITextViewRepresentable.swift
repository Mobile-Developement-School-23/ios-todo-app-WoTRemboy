//
//  UITextViewRepresentable.swift
//  School_ToDoList-SUI
//
//  Created by Roman Tverdokhleb on 21.07.2023.
//

import SwiftUI
import UIKit

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 15, bottom: 12, right: 16)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper

        init(_ parent: UITextViewWrapper) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}
