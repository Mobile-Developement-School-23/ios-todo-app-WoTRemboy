//
//  BothTableViewCell.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class BothTableViewCell: UITableViewCell {
    
    static let identifier = "BothViewsCell"
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "14 июня"
        label.numberOfLines = 1
        label.textColor = UIColor(named: "LabelTertiary")
        label.font = .subhead()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let calendarImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(
            systemName: "calendar",
            withConfiguration: UIImage.SymbolConfiguration(
                paletteColors: [UIColor(named: "LabelTertiary") ?? .red]))
        view.image = image
        
        return view
    }()
    
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
        dateLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
                
        contentView.addSubview(importanceImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(calendarImageView)
        contentView.addSubview(dateLabel)
        
        importanceImageViewSetup()
        titleLabelSetup()
        calendarImageViewSetup()
        dateLabelSetup()
        contentView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 12 + 12 + 4 + 15).isActive = true
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
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func calendarImageViewSetup() {
        calendarImageView.leadingAnchor.constraint(equalTo: importanceImageView.trailingAnchor, constant: 2).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func dateLabelSetup() {
        dateLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
