//
//  SegmentedControl.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(with: UIImage(named: "unimportant")?.withRenderingMode(.alwaysOriginal), at: 0, animated: false)
        control.insertSegment(withTitle: "нет", at: 1, animated: false)
        control.insertSegment(with: UIImage(named: "important")?.withRenderingMode(.alwaysOriginal), at: 2, animated: false)
        control.selectedSegmentIndex = 1
        
        return control
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentControl.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(segmentControl)
    }
    
}
