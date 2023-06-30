//
//  TableViewDelegates.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift
import FileCachePackage

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let newItemCellsCount = 1
        return sortedArray.count + newItemCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
        guard indexPath.row < sortedArray.count else { // for newTask cell
            cell.textLabel?.text = "Новое"
            cell.textLabel?.font = .body()
            cell.textLabel?.textColor = UIColor(named: "LabelTertiary")
            cell.imageView?.image = imageEmpty
            cell.accessoryView = nil
            cell.backgroundColor = UIColor(named: "BackSecondary")
            
            return cell
        }
        
        if doneTasksAreHidden { // hide done tasks by using EmptyTableViewCell
            if sortedArray[indexPath.row].completed {
                guard let cellEmpty: EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as? EmptyTableViewCell
                else {
                    DDLogError("EmptyTableViewCell config error", level: .error)
                    fatalError()
                }
                
                return cellEmpty
            }
        }
        
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 16)
        cell.textLabel?.numberOfLines = 3
        
        /* there is my logic:
         
         deadline
                 importance
                           BothTableViewCell
                 !importance
                           DeadlineTableViewCell
         !deadline
                 importance
                           ImportantTableViewCell
                 !importance
                           DefaultTableViewCell
         
         */
        
        if sortedArray[indexPath.row].deadline != nil {
            if sortedArray[indexPath.row].importance == .important || sortedArray[indexPath.row].importance == .unimportant { // deadline && important
                
                guard let cellDeadlineImportant: BothTableViewCell = tableView.dequeueReusableCell(withIdentifier: BothTableViewCell.identifier, for: indexPath) as? BothTableViewCell
                else {
                    DDLogError("BothTableViewCell config error", level: .error)
                    fatalError()
                }
                
                let item = sortedArray[indexPath.row]
                
                cellDeadlineImportant.textLabel?.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDeadlineImportant.accessoryView = arrowImageView
                
                if item.completed {
                    let attributedString = NSAttributedString(string: item.taskText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    cellDeadlineImportant.textLabel?.attributedText = attributedString
                    cellDeadlineImportant.textLabel?.textColor = UIColor(named: "LabelTertiary")
                    cellDeadlineImportant.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellDeadlineImportant.textLabel?.attributedText = NSAttributedString(string: item.taskText)
                    cellDeadlineImportant.textLabel?.textColor = UIColor(named: "LabelPrimary")

                    if item.importance == .important { // red empty circle check
                        cellDeadlineImportant.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                    } else { // default empty cercle
                        cellDeadlineImportant.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                    }
                }
                
                if item.importance == .important { // !! or ↓ check
                    let image = UIImage(named: "importantCell")?.withTintColor(UIColor(named: "Red") ?? .red)
                    cellDeadlineImportant.importanceImageView.image = image
                } else {
                    let image = UIImage(named: "unimportantCell")?.withTintColor(UIColor(named: "Grey") ?? .gray)
                    cellDeadlineImportant.importanceImageView.image = image
                }
                
                // working with deadline
                let timeStartFormatter = DateFormatter()
                timeStartFormatter.dateFormat = "dd MMMM"
                
                let fromDate = timeStartFormatter.string(from: item.deadline ?? Date())
                cellDeadlineImportant.dateLabel.text = "\(fromDate)"
                
                return cellDeadlineImportant
                
            } else { // deadline && !important
                guard let cellDeadline: DeadlineTableViewCell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.identifier, for: indexPath) as? DeadlineTableViewCell
                else {
                    DDLogError("DeadlineTableViewCell config error", level: .error)
                    fatalError()
                }
                let item = sortedArray[indexPath.row]
                
                cellDeadline.textLabel?.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDeadline.accessoryView = arrowImageView
                
                if item.completed {
                    let attributedString = NSAttributedString(string: item.taskText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    cellDeadline.textLabel?.attributedText = attributedString
                    cellDeadline.textLabel?.textColor = UIColor(named: "LabelTertiary")
                    cellDeadline.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellDeadline.textLabel?.attributedText = NSAttributedString(string: item.taskText)
                    cellDeadline.textLabel?.textColor = UIColor(named: "LabelPrimary")
                    cellDeadline.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                }
                
                // working with deadline
                let timeStartFormatter = DateFormatter()
                timeStartFormatter.dateFormat = "dd MMMM"
                
                let fromDate = timeStartFormatter.string(from: item.deadline ?? Date())
                cellDeadline.dateLabel.text = "\(fromDate)"
                
                return cellDeadline
            }
            
        } else { // !deadline && important
            
            if sortedArray[indexPath.row].importance == .important || sortedArray[indexPath.row].importance == .unimportant {
                
                guard let cellImportant: ImportantTableViewCell = tableView.dequeueReusableCell(withIdentifier: ImportantTableViewCell.identifier, for: indexPath) as? ImportantTableViewCell
                else {
                    DDLogError("ImportantTableViewCell config error", level: .error)
                    fatalError()
                }
                
                let item = sortedArray[indexPath.row]
                
                cellImportant.textLabel?.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellImportant.accessoryView = arrowImageView
                
                if item.completed {
                    let attributedString = NSAttributedString(string: item.taskText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    cellImportant.textLabel?.attributedText = attributedString
                    cellImportant.textLabel?.textColor = UIColor(named: "LabelTertiary")
                    cellImportant.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellImportant.textLabel?.attributedText = NSAttributedString(string: item.taskText)
                    cellImportant.textLabel?.textColor = UIColor(named: "LabelPrimary")
                    if item.importance == .important { // red empty circle check
                        cellImportant.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                    } else {
                        cellImportant.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                    }
                }
                
                if item.importance == .important { // !! or ↓ check
                    let image = UIImage(named: "importantCell")?.withTintColor(UIColor(named: "Red") ?? .red)
                    cellImportant.importanceImageView.image = image
                } else {
                    let image = UIImage(named: "unimportantCell")?.withTintColor(UIColor(named: "Grey") ?? .gray)
                    cellImportant.importanceImageView.image = image
                }
                
                return cellImportant
                
            } else { // !deadline && !important
                
                guard let cellDefault: DefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell
                else {
                    DDLogError("DefaultTableViewCell config error", level: .error)
                    fatalError()
                }
                
                let item = sortedArray[indexPath.row]
                
                cellDefault.textLabel?.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDefault.accessoryView = arrowImageView
                
                if item.completed {
                    let attributedString = NSAttributedString(string: item.taskText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    cellDefault.textLabel?.attributedText = attributedString
                    cellDefault.textLabel?.textColor = UIColor(named: "LabelTertiary")
                    cellDefault.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellDefault.textLabel?.attributedText = NSAttributedString(string: item.taskText)
                    cellDefault.textLabel?.textColor = UIColor(named: "LabelPrimary")
                    cellDefault.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                }
                
                return cellDefault
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == sortedArray.count { // newTask cell check
            newTaskCreate()
        } else {
            let viewController = DetailsViewController(openType: .edit, item: sortedArray[indexPath.row])
            viewController.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate, toDelete in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, completed: completed, createDate: createDate, editDate: editDate)
                
                if !toDelete { // DetailsVC Save button pressed
                    self.sortedArray.insert(item, at: indexPath.row)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    _ = self.fileCache.add(item: item)
                    
                } else { // DetailsVC Delete button pressed
                    if item.completed {
                        self.completedCount -= 1
                        self.headerSetup()
                    }
                    tableView.reloadData()
                    _ = self.fileCache.remove(at: id)
                }
                DispatchQueue.main.async {
                    self.fileCache.saveToFile(to: "testFile")
                }
            }
            
            let navVC = UINavigationController(rootViewController: viewController)
            present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Swipe actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        
        let item = sortedArray[indexPath.row]
        let isDone = item.completed
        
        let action = UIContextualAction(style: .normal, title: "") { (_, _, completionHandler) in
            
            var itemDone = false
            if !isDone {
                DispatchQueue.main.async {
                    let attributedString = NSAttributedString(string: item.taskText, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
                    cell?.textLabel?.attributedText = attributedString
                }
                cell?.textLabel?.textColor = UIColor(named: "LabelTertiary")
                cell?.imageView?.image = UIImage(named: "doneCircle")
                itemDone = true
                self.completedCount += 1
                DDLogDebug("\(item.taskText) is done", level: .debug)
                if self.doneTasksAreHidden { // to hide done task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    cell?.textLabel?.attributedText = NSAttributedString(string: item.taskText)
                }

                cell?.textLabel?.textColor = UIColor(named: "LabelPrimary")
                if item.importance == .important {
                    cell?.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                } else {
                    cell?.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                }
                itemDone = false
                self.completedCount -= 1
                DDLogDebug("\(item.taskText) is undone", level: .debug)
            }
            let newItem = ToDoItem(id: item.id, taskText: item.taskText, importance: item.importance, deadline: item.deadline, completed: itemDone, createDate: item.createDate, editDate: item.editDate)
            self.headerSetup()
            self.sortedArray[indexPath.row] = newItem
            
            DispatchQueue.main.async {
                _ = self.fileCache.add(item: newItem)
                self.fileCache.saveToFile(to: "testFile")
            }
            completionHandler(true)
        }
        if !isDone {
            action.backgroundColor = UIColor(named: "Green")
            action.image = imageCheckSwipe
        } else {
            action.backgroundColor = UIColor(named: "GrayLight")
            action.image = imageUncheckSwipe
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        let item = sortedArray[indexPath.row]
        
        let detailsAction = UIContextualAction(style: .normal, title: "") { (_, _, completionHandler) in
            
            let viewController = DetailsViewController(openType: .edit, item: self.sortedArray[indexPath.row])
            
            viewController.completionHandler = { id, taskText, importance, deadline, completed, createDate, _, toDelete in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, completed: completed, createDate: createDate)
                
                if !toDelete { // pressed DetailsVC Save button
                    self.sortedArray.insert(item, at: indexPath.row)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    _ = self.fileCache.add(item: item)
                } else { // pressed DetailsVC Delete button
                    if item.completed {
                        self.completedCount -= 1
                        self.headerSetup()
                    }
                    tableView.reloadData()
                    _ = self.fileCache.remove(at: id)
                }
                tableView.reloadRows(at: [indexPath], with: .none)
                DispatchQueue.main.async {
                    self.fileCache.saveToFile(to: "testFile")
                }
            }
            let navVC = UINavigationController(rootViewController: viewController)
            self.present(navVC, animated: true)
            completionHandler(true)
        }
        
        detailsAction.backgroundColor = UIColor(named: "GrayLight")
        detailsAction.image = imageInfo
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
            
            if self.sortedArray[indexPath.row].completed { // countLabel update
                self.completedCount -= 1
                self.headerSetup()
            }
            
            tableView.beginUpdates()
            self.sortedArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            DispatchQueue.main.async {
                _ = self.fileCache.remove(at: item.id)
                self.fileCache.saveToFile(to: "testFile")
            }
            DDLogDebug("\(item.taskText) is deleted", level: .debug)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Red")
        deleteAction.image = imageTrash
        
        return UISwipeActionsConfiguration(actions: [deleteAction, detailsAction])
    }
    
    // MARK: Context menu config
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.row < sortedArray.count else {
            return nil
        }
        var item: ToDoItem? = nil
        DispatchQueue.main.async {
            item = self.sortedArray[indexPath.row]
        }

        let previewProvider: () -> UIViewController? = {
            let detailsVC = DetailsViewController(openType: .edit, item: item)
            return detailsVC
        }
        
        let actionsProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            
            let editAction = UIAction(title: "Изменить", image: UIImage(systemName: "pencil")) { [weak self] _ in
                
                let viewController = DetailsViewController(openType: .edit, item: self?.sortedArray[indexPath.row])
                viewController.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate, toDelete in
                    
                    self?.sortedArray.remove(at: indexPath.row)
                    let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, completed: completed, createDate: createDate, editDate: editDate)
                    
                    if !toDelete { // DetailsVC Save button pressed
                        self?.sortedArray.insert(item, at: indexPath.row)
                        tableView.reloadRows(at: [indexPath], with: .none)
                        _ = self?.fileCache.add(item: item)
                        
                    } else { // DetailsVC Delete button pressed
                        if item.completed {
                            self?.completedCount -= 1
                            self?.headerSetup()
                        }
                        tableView.reloadData()
                        _ = self?.fileCache.remove(at: id)
                    }
                    DispatchQueue.main.async {
                        self?.fileCache.saveToFile(to: "testFile")
                    }
                }
                let navVC = UINavigationController(rootViewController: viewController)
                self?.present(navVC, animated: true)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                
                if self?.sortedArray[indexPath.row].completed == true {
                    self?.completedCount -= 1
                    self?.headerSetup()
                }
                
                tableView.beginUpdates()
                self?.sortedArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                DispatchQueue.main.async {
                    _ = self?.fileCache.remove(at: item?.id ?? "")
                    self?.fileCache.saveToFile(to: "testFile")
                }
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider, actionProvider: actionsProvider)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let detailsVC = animator.previewViewController as? DetailsViewController else {
            return
        }
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
