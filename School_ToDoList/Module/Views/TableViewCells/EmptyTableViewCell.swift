//
//  EmptyTableViewCell.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    static let identifier = "EmptyCell"
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
        separatorInset = UIEdgeInsets(top: 0, left: .infinity, bottom: 0, right: .infinity)
                        
        contentView.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }

}
