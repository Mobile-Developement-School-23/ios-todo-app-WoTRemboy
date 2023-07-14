//
//  MainViewController.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 28.06.2023.
//

import UIKit
import CocoaLumberjackSwift
import FileCachePackage

class MainViewController: UIViewController {
    
    // MARK: API points
    
    var revision = 0
    var isDirty = false
    let networkingService = DefaultNetworkingService()
    let fileCacheSQL = FileCacheSQL()
    let fileCacheCoreData = FileCacheCoreData()
        
    // MARK: ToDoItems initialization and sorting
    
    let items: [String: ToDoItem]
    var sortedArray = [ToDoItem]()
    let fileCache = FileCache()
    
    // MARK: Variables initialization
    
    var completedCount = -3
    var doneTasksAreHidden = false
    
    // MARK: TableView, Labels and Images initialization
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let refreshControl = UIRefreshControl() // to do sync in a hard way
    
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
    
    // MARK: Sorting loaded toDoItems by createDate
    
    init(items: [String: ToDoItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        let values = Array(items.values)
        let sortedValues = values.sorted { $0.createDate > $1.createDate }
        sortedArray = sortedValues.map { $0 }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Main Part
    
    override func viewWillAppear(_ animated: Bool) {
        serverFirstSyncItems()
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogDebug("Main view loaded", level: .debug)
                        
        completedCount = items.values.filter { $0.completed }.count
        DDLogInfo("All tasks: \(items.count); Completed tasks: \(completedCount)", level: .info)
                
        title = "Мои дела"
        view.backgroundColor = UIColor(named: "BackPrimary")
        tableView.backgroundColor = nil
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableViewRegisterCells()
        
        view.addSubview(tableView)
        view.addSubview(floatingButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        
        tableViewSetup()
        floatingButtonSetup()
        headerSetup()
        largeTitleCustomMargins()
    }
    
    // MARK: TableView and it's header setups
    
    func tableViewRegisterCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(BothTableViewCell.self, forCellReuseIdentifier: "BothViewsCell")
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: "DeadlineCell")
        tableView.register(ImportantTableViewCell.self, forCellReuseIdentifier: "ImportantCell")
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: "EmptyCell")
    }
    
    func tableViewSetup() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func headerSetup() {
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
    
    // MARK: Making large title custom margins
    
    func largeTitleCustomMargins() {
        let currentMargins = navigationController?.navigationBar.layoutMargins
        let tableViewLeading = 16
        let tableViewHeaderLeading = 16
        let leftMargin = tableViewLeading + tableViewHeaderLeading
        let newMargins = UIEdgeInsets(top: currentMargins?.top ?? 0.0, left: CGFloat(leftMargin), bottom: currentMargins?.bottom ?? 0.0, right: currentMargins?.right ?? 0.0)
        
        navigationController?.navigationBar.layoutMargins = newMargins
    }
    
    // MARK: Floating button
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 60,
                                            height: 60))
        
        button.backgroundColor = UIColor(named: "Blue")
        button.tintColor = .white
        
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        
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
    
    // MARK: @objc functions
    
    @objc func newTaskCreate() {
        DDLogDebug("Command to new task", level: .debug)
        let viewController = DetailsViewController(openType: .add, item: nil)
        
        viewController.completionHandler = { id, taskText, importance, deadline, _, createDate, _, _ in
            
            let item = ToDoItem(id: id, taskText: taskText, importance: importance, deadline: deadline, createDate: createDate)
            self.sortedArray.insert(item, at: 0)
            self.tableView.reloadData()
            DispatchQueue.main.async {
                self.fileCacheSQL.insertToDatabaseSQL(item: item)
                self.fileCacheCoreData.insertToDatabaseCoreData(item: item)
            }
            self.serverAddItem(item: item)
        }
        let navVC = UINavigationController(rootViewController: viewController)
        present(navVC, animated: true)
    }
    
    @objc func showButtonTapped() {
        doneTasksAreHidden = !doneTasksAreHidden
        if doneTasksAreHidden {
            DDLogDebug("Hide button pressed", level: .debug)
            showButton.setTitle("Показать", for: .normal)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: visibleIndexPaths, with: .fade)
            }
        } else {
            DDLogDebug("Show button pressed", level: .debug)
            showButton.setTitle("Скрыть", for: .normal)
            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
                tableView.reloadRows(at: visibleIndexPaths, with: .fade)
            }
        }
    }
    
    @objc private func refreshData() {
        serverSyncItems()
        refreshControl.endRefreshing()
    }
    
    // MARK: Internet trips functions
    
    func updatingListFromServer(items: [ToDoItem], sortedArray: [ToDoItem]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.fileCacheSQL.saveToDatabaseSQL(items: items)
            self.fileCacheCoreData.saveToDatabaseCoreData(items: items)
            self.completedCount = items.filter { $0.completed }.count
            self.headerSetup()
        }
    }
    
    func serverFirstSyncItems() {
        self.networkingService.getList { [weak self] result in
            switch result {
            case .success(let (items, revision)):
                let sortedValues = items.sorted { $0.createDate > $1.createDate }
                let array = sortedValues.map { $0 }
                let completedCountServer = items.filter { $0.completed }.count
                
                guard let sortedArray = self?.sortedArray else { return }
                let completedCountLocal = sortedArray.filter { $0.completed }.count
                
                if sortedArray.count != array.count || completedCountLocal != completedCountServer {
                    self?.sortedArray = array
                    self?.updatingListFromServer(items: items, sortedArray: sortedArray)
                }
                self?.revision = revision
                self?.isDirty = false
                DDLogDebug("Successful server first synced", level: .debug)
            case .failure(let error):
                self?.isDirty = true
                DDLogError("Unsuccessful server first synced: \(error)", level: .error)
            }
        }
    }
    
    func serverSyncItems() {
        self.networkingService.getList { [weak self] result in
            switch result {
            case .success(let (items, revision)):
                let sortedValues = items.sorted { $0.createDate > $1.createDate }
                let array = sortedValues.map { $0 }
                guard let sortedArray = self?.sortedArray else { return }
                
                    /* При успешном прохождении запроса синхронизации
                     обновляем список дел тем что отдал сервер
                     
                     Я бы сделал наоборот, что обновил данные на сервере, но по заданию так... */
                
                self?.sortedArray = array
                self?.updatingListFromServer(items: items, sortedArray: sortedArray)
                
                self?.revision = revision
                self?.isDirty = false
                DDLogDebug("Successful server synced", level: .debug)
            case .failure(let error):
                self?.isDirty = true
                DDLogError("Unsuccessful server synced: \(error)", level: .error)
            }
        }
    }
    
    func serverAddItem(item: ToDoItem) {
        if isDirty {
            serverSyncItems()
        }
        self.networkingService.addItem(revision: self.revision, item: item) { result in
            switch result {
            case .success:
                DDLogDebug("Successful server posted '\(item.taskText)'", level: .debug)
                self.revision += 1
            case .failure(let error):
                self.isDirty = true
                DDLogError("Unsuccessful server posted '\(item.taskText)': \(error)", level: .error)
                print(self.revision)
            }
        }
    }
    
    func serverDeleteItem(item: ToDoItem) {
        if isDirty {
            serverSyncItems()
        }
            self.networkingService.deleteItem(id: item.id, revision: self.revision) { result in
                switch result {
                case .success:
                    DDLogDebug("Successful server deleted '\(item.taskText)'", level: .debug)
                    self.revision += 1
                case .failure(let error):
                    self.isDirty = true
                    DDLogError("Unsuccessful server deleted '\(item.taskText)': \(error)", level: .error)
                    print(self.revision)
                }
            }
        
    }
    
    func serverUpdateItem(item: ToDoItem) {
        if isDirty {
            serverSyncItems()
        }
        self.networkingService.updateItem(id: item.id, revision: self.revision, item: item) { result in
            switch result {
            case .success:
                DDLogDebug("Successful server changed item to '\(item)'", level: .debug)
                self.revision += 1
            case .failure(let error):
                self.isDirty = true
                DDLogError("Unsuccessful server changed item to '\(item)': \(error)", level: .error)
                print(self.revision)
            }
        }
        
    }
}
