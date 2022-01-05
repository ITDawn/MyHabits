//
//  NewHabitViewController.swift
//  MyHabits
//
//  Created by Dany on 07.10.2021.
//

import UIKit
import Combine

enum HabitSet {
    case createHabit
    case editHabit
}


class NewHabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    
   
    
    var newHabit = Habit(name: "Выпить стакан воды", date: Date(), color: .systemPink)
    var cancellable: AnyCancellable?
    
    var habitSet = HabitSet.createHabit
    
    weak var delegate1: UpdateCollectionView?
    
    var delegate2: Callback?
    
    
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var colorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var everyDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var nameTextField: UITextField = {
        var textField = UITextField()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Бегать по утрам, спасть 8 часов и т.п."
        textField.clearButtonMode = .always
        textField.textColor = .systemGray4
        textField.backgroundColor = .white
        textField.textColor = .systemBlue
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var pickedTimdeLabel: UILabel = {
        let label = UILabel()
        label.text = " \(dateFormatter.string(from: timePicker.date))"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    let circleImage: UIImageView = {
        let doneImage = UIImageView()
        doneImage.contentMode = .scaleToFill
        doneImage.image = UIImage(systemName: "circle")
        doneImage.tintColor = .white
        doneImage.image?.withTintColor(UIColor.white)
        doneImage.translatesAutoresizingMaskIntoConstraints = false
        return doneImage
    }()
    
    
    
    
    private let someView: UIView = {
        let tableView = UIView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let picker = UIColorPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        colorView.addGestureRecognizer(gesture)
        gesture.numberOfTouchesRequired = 1
        picker.delegate = self

        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorView)
        view.addSubview(timeLabel)
        view.addSubview(timePicker)
        view.addSubview(colorLabel)
        view.addSubview(everyDayLabel)
        view.addSubview(pickedTimdeLabel)
        view.addSubview(circleImage)

        view.backgroundColor = .white
        self.title = "Создать"
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        let navItem = UINavigationItem()
        
        let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back))
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveTap(_:)))
        leftBarButtonItem.tintColor = .systemPurple
        rightBarButtonItem.tintColor = .systemPurple
        navItem.rightBarButtonItem = rightBarButtonItem
        navItem.leftBarButtonItem = leftBarButtonItem
        switch habitSet {
            case .createHabit: navItem.title = "Создать"
            case .editHabit: navItem.title = "Править"
        }
        
        navBar.setItems([navItem], animated: true)
        navBar.backgroundColor = .systemGray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(back))
        
        let constraints = [
            
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
                         navBar.heightAnchor.constraint(equalToConstant: 44),
                         navBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            nameTextField.heightAnchor.constraint(equalToConstant: 20),
            
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            colorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 15),
            colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            
            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            everyDayLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            everyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            everyDayLabel.heightAnchor.constraint(equalToConstant: 20),
            everyDayLabel.widthAnchor.constraint(equalToConstant: 150),
            
            pickedTimdeLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor),
            pickedTimdeLabel.centerYAnchor.constraint(equalTo: everyDayLabel.centerYAnchor),
            
            
            timePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 30),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            timePicker.heightAnchor.constraint(equalToConstant: 300),
            
            circleImage.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            circleImage.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            circleImage.heightAnchor.constraint(equalToConstant: 41),
            circleImage.widthAnchor.constraint(equalTo: circleImage.heightAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
  
    
    @objc func colorTapped() {
        print("hello")
        self.present(picker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
                self.colorView.backgroundColor = viewController.selectedColor
        newHabit.color = viewController.selectedColor
        }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tap() {
        let nc2 = UINavigationController(rootViewController: EditViewController())
        nc2.modalPresentationStyle = .overFullScreen
        nc2.modalTransitionStyle = .crossDissolve
        present(nc2, animated: true, completion: nil)

    }
    
    @objc func saveTap(_ sender: Any) {
        
        switch habitSet {
        case .createHabit: do {
            newHabit.name = nameTextField.text ?? ""
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            delegate1?.reloadView()
            
            dismiss(animated: true, completion: nil)
        }
        case .editHabit: do {
            newHabit.name = nameTextField.text ?? ""
            newHabit.date = timePicker.date
            newHabit.color = picker.selectedColor
           
            delegate1?.reloadView()
            dismiss(animated: true, completion: nil)
        }
    }
}

@objc func datePickerChanged(picker: UIDatePicker) {
    switch habitSet {
    case .createHabit: do {
        newHabit.date = timePicker.date
        }
    case .editHabit: do {
        
    }
    }
    pickedTimdeLabel.text = " \(dateFormatter.string(from: timePicker.date))"
}
    
}