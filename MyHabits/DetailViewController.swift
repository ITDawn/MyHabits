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

class DetailViewController: UIViewController, Callback {
    
    weak var delegate1: UpdateCollectionView?
    
    lazy var cellID = DetailTableViewCell()
    
    func callback() {
        navigationController?.popViewController(animated: true)
    }
    
    weak var titleDelegate: HabitsViewController?

    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(),icon: "",  color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate1?.reloadView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate1?.reloadView()
    }
    

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    
    /// Изменение привычки
    @objc func editPress(_ sender: Any) {
        let vc = NewHabitViewController()
        vc.newHabit = habit
        vc.habitSet = .editHabit
        vc.nameTextField.text = habit.name
        vc.colorView.backgroundColor = habit.color
        vc.timePicker.date = habit.date
        vc.nameTextField.textColor = habit.color
        vc.delegate2 = self
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.modalPresentationStyle = .overCurrentContext
        rootVC.modalTransitionStyle = .coverVertical
        present(rootVC, animated: true, completion: nil)
    }
    
    func setUpViews() {
        
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
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        if self.view.frame.height < 700 {
            return min(9, HabitsStore.shared.dates.count)
        } else if self.view.frame.height > 900 {
            return min(20, HabitsStore.shared.dates.count)
        } else  {
            return min(15, HabitsStore.shared.dates.count)
        }
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




