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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body()
        label.textColor = UIColor(named: "LabelPrimary")
        label.numberOfLines = 3
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
                
        contentView.addSubview(titleLabel)
        
        titleLabelSetup()
        contentView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 12 + 12 + 4).isActive = true
    }
    
    func titleLabelSetup() {
        titleLabel.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
