//
//  MainViewController.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 28.06.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    let items: [String : ToDoItem]
    var sortedArray = [ToDoItem]()
    let fileCache = FileCache()
    
    var completedCount = -3
    var doneTasksAreHidden = true
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let imageCheckSwipe = UIImage(
        systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.systemGreen, .white]))
    
    let imageInfo = UIImage(
        systemName: "info.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [UIColor(named: "GrayLight") ?? .gray, UIColor(named: "White") ?? .white]))
    
    let imageTrash = UIImage(
        systemName: "trash.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [UIColor(named: "White") ?? .white]))
    
    let imageEmpty = UIImage(
        systemName: "trash.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.clear]))
    
    let imageUncheckSwipe = UIImage(
        systemName: "x.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .systemRed]))
    
    init(items: [String: ToDoItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        let values = Array(items.values)
        let sortedValues = values.sorted { $0.createDate > $1.createDate }
        sortedArray = sortedValues.map { $0 }
        print(sortedArray)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileCache.loadFromFile(from: "testFile")
        print(fileCache.items)
        
        completedCount = items.values.filter { $0.completed }.count
        
        title = "Мои дела"
        view.backgroundColor = UIColor(named: "BackPrimary")
        tableView.backgroundColor = nil
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(BothTableViewCell.self, forCellReuseIdentifier: "BothViewsCell")
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: "DeadlineCell")
        tableView.register(ImportantTableViewCell.self, forCellReuseIdentifier: "ImportantCell")
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: "EmptyCell")
        
        
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButtonSetup()
        headerSetup()
        
        let currentMargins = navigationController?.navigationBar.layoutMargins
        let tableViewLeading = 16
        let tableViewHeaderLeading = 16
        let leftMargin = tableViewLeading + tableViewHeaderLeading
        let newMargins = UIEdgeInsets(top: currentMargins?.top ?? 0.0, left: CGFloat(leftMargin), bottom: currentMargins?.bottom ?? 0.0, right: currentMargins?.right ?? 0.0)
        
        navigationController?.navigationBar.layoutMargins = newMargins
        
    }
    
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 60,
                                            height: 60))
        
        button.backgroundColor = UIColor(named: "Blue")
        button.tintColor = .white
        
        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 32,
                weight: .medium))
        
        button.setImage(image, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private func floatingButtonSetup() {
        
        floatingButton.widthAnchor.constraint(
            equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(
            equalToConstant: 50).isActive = true
        floatingButton.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        floatingButton.bottomAnchor.constraint(
            equalTo: self.view.layoutMarginsGuide.bottomAnchor,
            constant: -10).isActive = true
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        floatingButton.addTarget(self, action: #selector(newTaskCreate), for: .touchUpInside)
    }
    
    @objc func newTaskCreate() {
        let viewController = DetailsViewController(openType: .add, item: nil)
        
        viewController.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate, toDelete in
            
            let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, createDate: createDate)
            self.sortedArray.insert(item, at: 0)
            self.tableView.reloadData()
            let _ = self.fileCache.add(item: item)
            print(self.fileCache.items)
            self.fileCache.saveToFile(to: "testFile")
            
        }
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
    func oldTaskEdit(item: ToDoItem) {
        let viewController: UIViewController = DetailsViewController(openType: .edit, item: item)
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .subhead()
        label.textColor = UIColor(named: "LabelTertiary")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(UIColor(named: "Blue"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func headerSetup() {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: 40))
        
        countLabel.text = "Выполнено — \(completedCount)"
        header.addSubview(countLabel)
        header.addSubview(showButton)
        
        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        
        countLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 32).isActive = true
        countLabel.widthAnchor.constraint(lessThanOrEqualToConstant: header.frame.width/2).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        
        showButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -32).isActive = true
        showButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        showButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
        if doneTasksAreHidden {
            showButton.setTitle("Показать", for: .normal)
        } else {
            showButton.setTitle("Скрыть", for: .normal)
        }
        tableView.tableHeaderView = header
        
    }
    
    @objc func showButtonTapped() {
        doneTasksAreHidden = !doneTasksAreHidden
        if doneTasksAreHidden {
            showButton.setTitle("Показать", for: .normal)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: visibleIndexPaths, with: .fade)
            }
        } else {
            showButton.setTitle("Скрыть", for: .normal)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: visibleIndexPaths, with: .fade)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
        guard indexPath.row < sortedArray.count else {
            cell.textLabel?.text = "Новое"
            cell.textLabel?.font = .body()
            cell.textLabel?.textColor = UIColor(named: "LabelTertiary")
            cell.imageView?.image = imageEmpty
            cell.accessoryView = nil
            cell.backgroundColor = UIColor(named: "BackSecondary")

            return cell
        }
        
        if doneTasksAreHidden {
            if sortedArray[indexPath.row].completed {
                guard let cellEmpty: EmptyTableViewCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as? EmptyTableViewCell
                else {
                    fatalError()
                }
                
                return cellEmpty
            }
        }
        
        cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 16)
        cell.textLabel?.numberOfLines = 3
        if sortedArray[indexPath.row].deadline != nil {
            if sortedArray[indexPath.row].importance == .important || sortedArray[indexPath.row].importance == .unimportant {
                guard let cellDeadlineImportant: BothTableViewCell = tableView.dequeueReusableCell(withIdentifier: BothTableViewCell.identifier, for: indexPath) as? BothTableViewCell
                else {
                    fatalError()
                }
                let item = sortedArray[indexPath.row]
                
                cellDeadlineImportant.titleLabel.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDeadlineImportant.accessoryView = arrowImageView
                if item.completed {
                    cellDeadlineImportant.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    if item.importance == .important {
                        cellDeadlineImportant.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                    } else {
                        cellDeadlineImportant.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                    }
                }
                
                if item.importance == .important {
                    let image = UIImage(named: "importantCell")?.withTintColor(UIColor(named: "Red") ?? .red)
                    cellDeadlineImportant.importanceImageView.image = image
                } else {
                    let image = UIImage(named: "unimportantCell")?.withTintColor(UIColor(named: "Grey") ?? .gray)
                    cellDeadlineImportant.importanceImageView.image = image
                }
                
                let timeStartFormatter = DateFormatter()
                timeStartFormatter.dateFormat = "dd MMMM"
                
                let fromDate = timeStartFormatter.string(from: item.deadline ?? Date())
                cellDeadlineImportant.dateLabel.text = "\(fromDate)"
                
                return cellDeadlineImportant
            } else {
                guard let cellDeadline: DeadlineTableViewCell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.identifier, for: indexPath) as? DeadlineTableViewCell
                else {
                    fatalError()
                }
                let item = sortedArray[indexPath.row]
                
                cellDeadline.titleLabel.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDeadline.accessoryView = arrowImageView
                if item.completed {
                    cellDeadline.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellDeadline.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                    
                }
                let timeStartFormatter = DateFormatter()
                timeStartFormatter.dateFormat = "dd MMMM"
                
                let fromDate = timeStartFormatter.string(from: item.deadline ?? Date())
                cellDeadline.dateLabel.text = "\(fromDate)"
                
                return cellDeadline
            }
            
        } else {
            
            if sortedArray[indexPath.row].importance == .important || sortedArray[indexPath.row].importance == .unimportant {
                guard let cellImportant: ImportantTableViewCell = tableView.dequeueReusableCell(withIdentifier: ImportantTableViewCell.identifier, for: indexPath) as? ImportantTableViewCell
                else {
                    fatalError()
                }
                let item = sortedArray[indexPath.row]
                
                cellImportant.titleLabel.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellImportant.accessoryView = arrowImageView
                if item.completed {
                    cellImportant.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    if item.importance == .important {
                        cellImportant.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                    } else {
                        cellImportant.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                    }
                }
                
                if item.importance == .important {
                    let image = UIImage(named: "importantCell")?.withTintColor(UIColor(named: "Red") ?? .red)
                    cellImportant.importanceImageView.image = image
                } else {
                    let image = UIImage(named: "unimportantCell")?.withTintColor(UIColor(named: "Grey") ?? .gray)
                    cellImportant.importanceImageView.image = image
                }
                
                return cellImportant
            } else {
                guard let cellDefault: DefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell
                else {
                    fatalError()
                }
                let item = sortedArray[indexPath.row]
                
                cellDefault.titleLabel.text = item.taskText
                let arrowImageView = UIImageView(image: UIImage(named: "transit"))
                cellDefault.accessoryView = arrowImageView
                if item.completed {
                    cellDefault.imageView?.image = UIImage(named: "doneCircle")
                } else {
                    cellDefault.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                }
                
                return cellDefault
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == sortedArray.count {
            newTaskCreate()
        } else {
            //oldTaskEdit(item: sortedArray[indexPath.row])
            let vc = DetailsViewController(openType: .edit, item: sortedArray[indexPath.row])
            vc.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate, toDelete in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, completed: completed, createDate: createDate, editDate: editDate)
                if !toDelete {
                    self.sortedArray.insert(item, at: indexPath.row)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    let _ = self.fileCache.add(item: item)
                } else {
                    if item.completed {
                        self.completedCount -= 1
                        self.headerSetup()
                    }
                    tableView.reloadData()
                    let _ = self.fileCache.remove(at: id)
                }
                print(self.fileCache.items)
                self.fileCache.saveToFile(to: "testFile")
                
                
            }
            
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        let item = sortedArray[indexPath.row]
        let isDone = item.completed
        
        let action = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            var itemDone = false
            if !isDone {
                cell?.imageView?.image = UIImage(named: "doneCircle")
                itemDone = true
                self.completedCount += 1
                if self.doneTasksAreHidden {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            } else {
                if item.importance == .important {
                    cell?.imageView?.image = UIImage(named: "importantCircle")?.withTintColor(UIColor(named: "Red") ?? .red)
                } else {
                    cell?.imageView?.image = UIImage(named: "emptyCircle")?.withTintColor(UIColor(named: "LabelSecondary") ?? .secondarySystemGroupedBackground)
                }
                itemDone = false
                self.completedCount -= 1
            }
            let newItem = ToDoItem(id: item.id, taskText: item.taskText, importance: item.importance, deadline: item.deadline, completed: itemDone, createDate: item.createDate, editDate: item.editDate)
            self.headerSetup()
            self.sortedArray[indexPath.row] = newItem
            
            let _ = self.fileCache.add(item: newItem)
            self.fileCache.saveToFile(to: "testFile")
            completionHandler(true)
        }
        if !isDone {
            action.backgroundColor = UIColor(named: "Green")
            action.image = imageCheckSwipe
        } else {
            action.backgroundColor = UIColor(named: "GrayLight")
            action.image = imageUncheckSwipe
            headerSetup()
        }
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row != sortedArray.count else {
            return nil
        }
        let item = sortedArray[indexPath.row]
        let detailsAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            
            let vc = DetailsViewController(openType: .edit, item: self.sortedArray[indexPath.row])
            vc.completionHandler = { id, taskText, importance, deadline, completed, createDate, editDate, toDelete in
                
                self.sortedArray.remove(at: indexPath.row)
                let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, completed: completed, createDate: createDate)
                if !toDelete {
                    self.sortedArray.insert(item, at: indexPath.row)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    let _ = self.fileCache.add(item: item)
                } else {
                    if item.completed {
                        self.completedCount -= 1
                        self.headerSetup()
                    }
                    tableView.reloadData()
                    let _ = self.fileCache.remove(at: id)
                }
                print(self.fileCache.items)
                self.fileCache.saveToFile(to: "testFile")
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            let navVC = UINavigationController(rootViewController: vc)
            self.present(navVC, animated: true)
            completionHandler(true)
        }
        detailsAction.backgroundColor = UIColor(named: "GrayLight")
        detailsAction.image = imageInfo
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            if self.sortedArray[indexPath.row].completed {
                self.completedCount -= 1
                self.headerSetup()
            }
            
            tableView.beginUpdates()
            self.sortedArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            let _ = self.fileCache.remove(at: item.id)
            self.fileCache.saveToFile(to: "testFile")
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Red")
        deleteAction.image = imageTrash
        
        return UISwipeActionsConfiguration(actions: [deleteAction, detailsAction])
    }
}
