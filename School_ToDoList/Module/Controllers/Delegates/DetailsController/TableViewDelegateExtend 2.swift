//
//  TableViewDelegateExtend.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 20.06.2023.
//

import UIKit

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
