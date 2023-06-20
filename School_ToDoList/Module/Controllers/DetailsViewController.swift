import UIKit

class DetailsViewController: UIViewController {
    
    let scrollView = CustomScrollView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentSize
    }
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: detailsTextView.frame.height + 300)
    }
    
    let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(buttonTapped))
    let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(buttonTapped))
    
    let detailsTextView = DetailsTextView()
    
    let tableView = UITableView()
    let tableViewController = DetailsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дело"
        view.backgroundColor = UIColor(named: "BackPrimary")
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        scrollView.frame = view.bounds
        tableViewConfiguration()
        
        detailsTextView.delegate = self
        tableView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailsTextView)
        scrollView.addSubview(tableView)
        scrollView.isScrollEnabled = true

        scrollViewSetup()
        detailsTextViewSetup()
        tableViewSetup()
    }
    
    @objc func buttonTapped() {
        
    }
    
    func detailsTextViewSetup() {
        detailsTextView.translatesAutoresizingMaskIntoConstraints = false
        detailsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        detailsTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        detailsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        detailsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    func tableViewConfiguration() {
        tableView.dataSource = tableViewController
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.topAnchor.constraint(equalTo: detailsTextView.bottomAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 112).isActive = true
    }
    
    func scrollViewSetup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}



