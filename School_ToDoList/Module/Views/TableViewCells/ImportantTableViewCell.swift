//
//  ImportantTableViewCell.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class ImportantTableViewCell: UITableViewCell {

    static let identifier = "ImportantCell"
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    let importanceImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "importantCell")?.withTintColor(UIColor(named: "Red") ?? .red)
        view.image = image
        
        return view
    }()
    
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
                
        contentView.addSubview(importanceImageView)
        contentView.addSubview(titleLabel)
        
        importanceImageViewSetup()
        titleLabelSetup()
        contentView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 12 + 12 + 4).isActive = true
    }
    
    func importanceImageViewSetup() {
        importanceImageView.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 12).isActive = true
        importanceImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        importanceImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        importanceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        importanceImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func titleLabelSetup() {
        titleLabel.leadingAnchor.constraint(equalTo: importanceImageView.trailingAnchor, constant: 2).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
