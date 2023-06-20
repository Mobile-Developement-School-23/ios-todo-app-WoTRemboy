//
//  TableViewController.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

class DetailsTableViewController: UITableView, UITableViewDataSource {
    var data = ["Важность", "Сделать до"]
    var datePickerVisible = false
    
    let segmentedControl = SegmentedControl(frame: .null)
    let switchControl = UISwitch()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.locale = .current
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        
        return picker
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = .body()
        cell.heightAnchor.constraint(equalToConstant: 56).isActive = true
        cell.backgroundColor = UIColor(named: "BackSecondary")
        
        if indexPath.row == 0 {
            
            segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
            cell.contentView.addSubview(segmentedControl)
            
            cell.contentView.heightAnchor.constraint(equalToConstant: 56).isActive = true
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            segmentedControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
        } else if indexPath.row == 1 {
            
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.contentView.addSubview(switchControl)
            
            cell.contentView.heightAnchor.constraint(equalToConstant: 56).isActive = true
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            switchControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            switchControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        } else {
            cell.contentView.addSubview(datePicker)
            cell.contentView.heightAnchor.constraint(equalToConstant: 332).isActive = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 2 && !datePickerVisible {
                return 0
            }
            return 56
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
        let calendarRowNumber = 2
        let myLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 200, height: 30))
        myLabel.text = "Hello, world!"
        
        if let cell = sender.superview?.superview as? UITableViewCell,
           let tableView = cell.superview as? UITableView {
            let isSwitchOn = sender.isOn
            
            if isSwitchOn {
                datePickerVisible = true
                data.insert("", at: calendarRowNumber)
                
                let doneUntil = IndexPath(row: 1, section: 0)
                let calendarIndexPath = IndexPath(row: calendarRowNumber, section: 0)
                
                tableView.beginUpdates()
                tableView.insertRows(at: [calendarIndexPath], with: .fade)
                tableView.endUpdates()
            } else {
                datePickerVisible = false
                data.remove(at: calendarRowNumber)
                
                let calendarIndexPath = IndexPath(row: calendarRowNumber, section: 0)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [calendarIndexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }

}
