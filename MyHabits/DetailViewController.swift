//
//  DetailViewController.swift
//  MyHabits
//
//  Created by Dany on 24.12.2021.
//

import UIKit
protocol Callback {
    func callback()
}

class DetailViewController: UIViewController, Callback, UpdateCollectionView {
    
    func reloadView() {
        let vc = HabitsViewController()
        vc.collectionView.reloadData()
    }
    
    
    
    lazy var cellID = DetailTableViewCell()
    
    func callback() {
            navigationController?.popToRootViewController(animated: true)
    }
    
    weak var titleDelegate: HabitsViewController?

    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.backgroundColor = .white
        self.title = "Активность"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editPress(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Сегодня", style: .done, target: self, action: #selector(back))
        let backButton = UIBarButtonItem()
        backButton.title = "My Back Button Title"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellID.identifier)
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    @objc func back() {
        titleDelegate?.preferLargeTitle()
        if titleDelegate?.preferLargeTitle() != nil {
            print("rddhgkjjlkl;k;ljjghg")
        }
       dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func editPress(_ sender: Any) {
        
        let vc = NewHabitViewController()
        vc.newHabit = habit
        vc.habitSet = .editHabit
        vc.nameTextField.text = habit.name
        vc.colorView.backgroundColor = habit.color
        vc.timePicker.date = habit.date
        vc.nameTextField.textColor = habit.color
        vc.delegate1 = self
        vc.delegate2 = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpViews() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countDates: Int = 0
        
        for date in HabitsStore.shared.dates {
            if HabitsStore.shared.habit(habit, isTrackedIn: date) {
                countDates += 1
            }
        }
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID.identifier, for: indexPath) as! DetailTableViewCell
        let storeDates: [Date] = HabitsStore.shared.dates.reversed()
        cell.textLabel?.text = dateFormatter.string(from: storeDates[indexPath.row])
        
        if HabitsStore.shared.habit(habit, isTrackedIn: storeDates[indexPath.row]) {
            cell.accessoryType  = .checkmark
            cell.tintColor = .purple
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



