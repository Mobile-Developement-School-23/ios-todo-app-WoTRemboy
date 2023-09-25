//
//  TextViewDelegateExtend.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

extension DetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your next task" && textView.textColor != UIColor(named: "LabelPrimary") {
            textView.text = nil
            textView.textColor = UIColor(named: "LabelPrimary")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your next task"
            textView.textColor = UIColor(named: "LabelTertiary")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

}
