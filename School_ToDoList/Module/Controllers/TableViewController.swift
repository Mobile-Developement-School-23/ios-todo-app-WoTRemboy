//
//  TableViewController.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

class DetailsTableViewController: UITableView, UITableViewDataSource {
    let data = ["Важность", "Сделать до"]
    
    let segmentedControl = SegmentedControl(frame: .null)
    let switchControl = UISwitch()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = .body()
        cell.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        if indexPath.row == 0 {
            
            segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
            cell.contentView.addSubview(segmentedControl)
            
            cell.contentView.heightAnchor.constraint(equalToConstant: 56).isActive = true
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            segmentedControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
        } else {
            
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.contentView.addSubview(switchControl)
            
            cell.contentView.heightAnchor.constraint(equalToConstant: 56).isActive = true
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            switchControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            switchControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        }
        
        return cell
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let tableView = cell.superview as? UITableView,
           let indexPath = tableView.indexPath(for: cell) {
            let row = indexPath.row
            let selectedSegment = sender.selectedSegmentIndex
            print("Segment changed in row \(row), selected segment: \(selectedSegment)")
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let tableView = cell.superview as? UITableView,
           let indexPath = tableView.indexPath(for: cell) {
            let row = indexPath.row
            let isSwitchOn = sender.isOn
            print("Switch changed in row \(row), is on: \(isSwitchOn)")
        }
    }
}
