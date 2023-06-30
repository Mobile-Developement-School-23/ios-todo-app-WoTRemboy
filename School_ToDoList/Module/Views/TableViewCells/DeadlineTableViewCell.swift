//
//  DeadlineTableViewCell.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 29.06.2023.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {

    static let identifier = "DeadlineCell"
    
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

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.attributedText = nil
        textLabel?.text = nil
        dateLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
        textLabel?.font = .body()
        textLabel?.textColor = UIColor(named: "LabelPrimary")
        textLabel?.numberOfLines = 3
                
        contentView.addSubview(calendarImageView)
        contentView.addSubview(dateLabel)
        
        titleLabelSetup()
        calendarImageViewSetup()
        dateLabelSetup()
        contentView.heightAnchor.constraint(equalTo: textLabel?.heightAnchor ?? contentView.heightAnchor, constant: 12 + 12 + 4 + 15).isActive = true
    }
    
    func importanceViewSetup() {
        
    }
    
    func titleLabelSetup() {
        textLabel?.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 16).isActive = true
        textLabel?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        textLabel?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func calendarImageViewSetup() {
        calendarImageView.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? contentView.leadingAnchor, constant: 16).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImageView.topAnchor.constraint(equalTo: textLabel?.bottomAnchor ?? contentView.topAnchor, constant: 2).isActive = true
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func dateLabelSetup() {
        dateLabel.leadingAnchor.constraint(equalTo: calendarImageView.trailingAnchor, constant: 2).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel?.bottomAnchor ?? contentView.topAnchor, constant: 1).isActive = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
