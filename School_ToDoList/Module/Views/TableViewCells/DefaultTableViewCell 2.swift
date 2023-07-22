//
//  DefaultTableViewCell.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    static let identifier = "DefaultCell"
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.attributedText = nil
        textLabel?.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
        textLabel?.font = .body()
        textLabel?.textColor = UIColor(named: "LabelPrimary")
        textLabel?.numberOfLines = 3
                        
        titleLabelSetup()
        contentView.heightAnchor.constraint(equalTo: textLabel?.heightAnchor ?? contentView.heightAnchor, constant: 16 + 16 + 4).isActive = true
    }
    
    func titleLabelSetup() {
        textLabel?.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 16).isActive = true
        textLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        textLabel?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
    }

}
