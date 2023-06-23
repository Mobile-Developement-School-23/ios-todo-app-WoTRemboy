import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource {
    
    let scrollView = CustomScrollView()
    
    var labelConstraint1: NSLayoutConstraint? = nil
    var dateLabelConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentSize
    }
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: detailsTextView.frame.height + tableView.frame.height + deleteButton.frame.height + 100)
    }
    
    let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(buttonTapped))
    let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(buttonTapped))
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor(named: "Red"), for: .normal)
        button.backgroundColor = UIColor(named: "BackSecondary")
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    let detailsTextView = DetailsTextView()
    
    let tableView = UITableView()
    //let tableViewController = DetailsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дело"
        view.backgroundColor = UIColor(named: "BackPrimary")
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        scrollView.frame = view.bounds
        scrollView.showsVerticalScrollIndicator = false
        tableViewConfiguration()
        
        detailsTextView.delegate = self
        tableView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailsTextView)
        scrollView.addSubview(tableView)
        scrollView.addSubview(deleteButton)
        scrollView.isScrollEnabled = true

        scrollViewSetup()
        detailsTextViewSetup()
        tableViewSetup()
        deleteButtonSetup()

    }
    
    @objc func buttonTapped() {
        
    }
    
    func deleteButtonSetup() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func detailsTextViewSetup() {
        detailsTextView.translatesAutoresizingMaskIntoConstraints = false
        detailsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        detailsTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        detailsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        detailsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    func tableViewConfiguration() {
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableViewSetup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        tableView.topAnchor.constraint(equalTo: detailsTextView.bottomAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        let constraint = tableView.heightAnchor.constraint(equalToConstant: 112)
        constraint.priority = .defaultLow
        constraint.isActive = true
        //tableView.heightAnchor.constraint(equalToConstant: 112).isActive = true
//        tableViewConstraint.isActive = true
        //tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16).isActive = true
    }
    
    func scrollViewSetup() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func doneUntilLabelSetup() {
        
    }
    
    var data = ["Важность", nil]
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
    
    let doneUntilLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = .body()
        
        return label
    }()
    
    let dateUntilLabel: UILabel = {
        let label = UILabel()
        label.text = "23 июня 2023"
        label.textColor = UIColor(named: "Blue")
        label.font = .footnote()
        
        return label
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = .body()
        //cell.heightAnchor.constraint(equalToConstant: 56).isActive = true
        cell.backgroundColor = UIColor(named: "BackSecondary")
        
        if indexPath.row == 0 {
            
            segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
            
            
            cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
            cell.contentView.addSubview(segmentedControl)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            segmentedControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            segmentedControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
        } else if indexPath.row == 1 {
            
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.contentView.addSubview(switchControl)
            cell.contentView.addSubview(doneUntilLabel)
            cell.contentView.addSubview(dateUntilLabel)
            dateUntilLabel.alpha = 0
            
            cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            switchControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -14).isActive = true
            switchControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            
//            let firstCell = IndexPath(row: 1, section: 0)
//            let labelConstraint = tableView.cellForRow(at: firstCell)?.textLabel?.leadingAnchor
            labelConstraint1 = doneUntilLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: 0)
            doneUntilLabel.translatesAutoresizingMaskIntoConstraints = false
            doneUntilLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
            labelConstraint1?.isActive = true
//            labelConstraint1?.priority = .defaultLow
            dateUntilLabel.translatesAutoresizingMaskIntoConstraints = false
            dateUntilLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16).isActive = true
            dateUntilLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: 10).isActive = true
        } else {
            cell.contentView.addSubview(datePicker)
            cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 332).isActive = true
        }
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            if indexPath.row == 2 && !datePickerVisible {
//                return 0
//            }
//            return 56
//        }
    
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
            let vc = DetailsViewController()

            let secondCell = IndexPath(row: 1, section: 0)
            
            
            let constraint1 = tableView.heightAnchor.constraint(equalToConstant: 112 + 332)
            let constraint2 = tableView.heightAnchor.constraint(equalToConstant: 112)
            let dateCell = IndexPath(row: 1, section: 0)

            if isSwitchOn {
                datePickerVisible = true
                data.insert("", at: calendarRowNumber)

                let calendarIndexPath = IndexPath(row: calendarRowNumber, section: 0)
                
                
                tableView.beginUpdates()
                tableView.insertRows(at: [calendarIndexPath], with: .fade)
                tableView.endUpdates()
                
                labelConstraint1?.constant -= 10
               
                constraint1.priority = .defaultHigh
                constraint2.priority = .defaultLow
                constraint1.isActive = true
                constraint2.isActive = false
                scrollView.contentSize = contentSize
                
                UIView.animate(withDuration: 0.5) {
                    //tableView.cellForRow(at: dateCell)?.textLabel?.alpha = 1
                    self.dateUntilLabel.alpha = 1
                   
 
                    //tableView.performBatchUpdates(nil, completion: nil)
                    //tableView.cellForRow(at: dateCell)?.textLabel?.text = "Привет"
                    self.scrollView.layoutIfNeeded()

                }
                
                
            } else {
                datePickerVisible = false
                data.remove(at: calendarRowNumber)
                
                let calendarIndexPath = IndexPath(row: calendarRowNumber, section: 0)
                
                
                
                constraint1.priority = .defaultLow
                constraint2.priority = .defaultHigh
                constraint1.isActive = false
                constraint2.isActive = true

                
                tableView.beginUpdates()
                tableView.deleteRows(at: [calendarIndexPath], with: .fade)
                tableView.endUpdates()
                
                
                
                tableView.cellForRow(at: dateCell)?.textLabel?.alpha = 1
                
                UIView.animate(withDuration: 0.5) {
                    self.labelConstraint1?.constant = 0
                    self.dateUntilLabel.alpha = 0

                    
                    //tableView.updateConstraints()
                    self.scrollView.layoutIfNeeded()
                }
            }
        }
    }
}



