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

public class NewHabitViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    let networkCheck = Reachability()
    weak var delegate1: UpdateCollectionView?
    var delegate2: Callback?
    var habitSet = HabitSet.createHabit
    var newHabit = Habit(name: "Выпить стакан воды", date: Date(), icon: "", color: .cyan)
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let noticeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: 45))
        label.text = "ТЫ ЛОШАРА"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let pushNoticeView: UIView = {
        let view = UIView(frame: CGRect(x: 110, y: -20, width: 200, height: 50))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.isHidden = true
        view.backgroundColor = .systemPink
        return view
    }()
    private let refreshButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 110, y: 800, width: 200, height: 60))
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addTarget(NewHabitViewController.self, action: #selector(saveTap(_:)), for: .touchUpInside)
        button.setTitle("повторить попытку", for: .normal)
        return button
    }()
    private let creationLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 130, y: 400, width: 200, height: 50))
        label.text = "Мероприятие создается"
        label.isHidden = true
        return label
    }()
    
    private let creationView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let creationImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        view.image = UIImage(named: "creation")
        view.isHidden = true
        return view
    }()
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    var nameTextField: UITextField = {
        var textField = UITextField()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.layer.cornerRadius = 7
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Бегать по утрам, спасть 8 часов и т.п."
        textField.clearButtonMode = .always
        textField.backgroundColor = .white
        textField.textColor = .cyan
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let picker = UIColorPickerViewController()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.tintColor = .red
        return button
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "НАЗВАНИЕ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var colorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "ВРЕМЯ"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var everyDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Каждый день в"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var pickedTimdeLabel: UILabel = {
        let label = UILabel()
        label.text = " \(dateFormatter.string(from: timePicker.date))"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let circleImage: UIImageView = {
        let doneImage = UIImageView()
        doneImage.contentMode = .scaleToFill
        doneImage.image = UIImage(systemName: "circle")
        doneImage.tintColor = .white
        doneImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        doneImage.layer.shadowRadius = 2
        doneImage.layer.shadowColor = UIColor.black.cgColor
        doneImage.layer.shadowOpacity = 0.3
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTap(tapGestureRecognizer:)))
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(viewTap(tapGestureRecognizer:)))
        deleteButton.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        timePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        self.view.addGestureRecognizer(viewGesture)
        nameTextField.addGestureRecognizer(tapGesture)
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
        view.addSubview(deleteButton)
        view.addSubview(creationView)
        creationView.addSubview(creationImageView)
        creationView.addSubview(creationLabel)
        creationView.addSubview(refreshButton)
        creationView.addSubview(pushNoticeView)
        pushNoticeView.addSubview(noticeLabel)
        view.backgroundColor = .systemGray5
        self.navigationController?.navigationBar.backgroundColor = .systemGray5
        title = "Создать"
        switch habitSet {
        case .createHabit: navigationController?.navigationItem.title = "Создать"
        case .editHabit:
            deleteButton.isHidden = false
            navigationController?.navigationItem.title = "Править"
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(back))
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            nameTextField.bottomAnchor.constraint(equalTo: colorLabel.topAnchor, constant: -20),
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            colorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorLabel.bottomAnchor.constraint(equalTo: colorView.topAnchor, constant: -20),
            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 20),
            colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
            colorView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -20),
            circleImage.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
            circleImage.centerXAnchor.constraint(equalTo: colorView.centerXAnchor),
            circleImage.heightAnchor.constraint(equalToConstant: 35),
            circleImage.widthAnchor.constraint(equalTo: circleImage.heightAnchor),
            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: everyDayLabel.topAnchor, constant: -20),
            everyDayLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            everyDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            everyDayLabel.trailingAnchor.constraint(equalTo: pickedTimdeLabel.leadingAnchor, constant: -20),
            everyDayLabel.bottomAnchor.constraint(equalTo: timePicker.topAnchor, constant: -20),
            pickedTimdeLabel.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor, constant: 20),
            pickedTimdeLabel.centerYAnchor.constraint(equalTo: everyDayLabel.centerYAnchor),
            timePicker.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            timePicker.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -100),
            deleteButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 100),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ]
        NSLayoutConstraint.activate(constraints)
        creationView.frame = CGRect(x: view.frame.midX, y: view.frame.midY, width: 50, height: 50)
        creationView.backgroundColor = .brown
        creationView.isHidden = true
    }
    /// Вызов pickerViewController
    @objc func colorTapped() {
        present(picker, animated: true, completion: nil)
    }
    
    public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.colorView.backgroundColor = viewController.selectedColor
        self.nameTextField.textColor = viewController.selectedColor
        newHabit.color = viewController.selectedColor
    }
    /// Закрытие NewHabitViewController
    @objc func back() {
        let vc = HabitsViewController()
        vc.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    /// Удаление привычки
    @objc func deleteHabit() {
        let alertVC = UIAlertController(title: "Удалить привычку?", message:"привычка '\(nameTextField.text ?? "")' будет удалена", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            HabitsStore.shared.habits.remove(at: HabitsStore.shared.habits.firstIndex(of: self.newHabit) ?? 0 )
            self.delegate2?.callback()
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(deleteAction)
        present(alertVC, animated: true, completion: nil)
    }
    /// Сохранение или изменение привычки
    @objc func saveTap(_ sender: Any) {
        let serialQueue = DispatchQueue.main
        serialQueue.async {
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [],
                                    animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [self] in
                    self.navigationController!.navigationBar.layer.zPosition = -1
                    self.tabBarController?.tabBar.layer.zPosition = -1
                    creationView.frame = view.bounds
                    creationView.isHidden = false
                }
            }, completion: {
                finished in
                UIView.animate(withDuration: 1) { [self] in
                    self.creationImageView.isHidden = false
                    self.creationLabel.isHidden = false
                    self.pushNoticeView.isHidden = false
                    serialQueue.asyncAfter(deadline: .now() + 1, execute: {
                        serialQueue.asyncAfter(deadline: .now() , execute: { [self] in
                            if networkCheck.isConnectedToNetwork() {
                                let habitStore = HabitsStore.shared
                                switch habitSet {
                                case .createHabit: do {
                                    newHabit.name = nameTextField.text ?? ""
                                    habitStore.habits.append(newHabit)
                                    navigationController?.popViewController(animated: true)
                                    delegate1?.reloadView()
                                }
                                case .editHabit: do {
                                    habitStore.habits.remove(at: HabitsStore.shared.habits.firstIndex(of: self.newHabit) ?? 0 )
                                    newHabit.name = nameTextField.text ?? ""
                                    newHabit.date = timePicker.date
                                    habitStore.habits.append(newHabit)
                                    delegate2?.callback()
                                    self.navigationController?.popViewController(animated: true)
                                    delegate1?.reloadView()
                                }
                                }
                            } else {
                                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [],
                                                        animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [self] in
                                        self.pushNoticeView.frame = CGRect(x: 110, y: 150, width: 200, height: 50)
                                        serialQueue.asyncAfter(wallDeadline: .now() + 0.3 , execute: {
                                            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [], animations: {
                                                self.pushNoticeView.frame = CGRect(x: 110, y: 140, width: 200, height: 50)
                                            }, completion: {
                                                finished in
                                                self.pushNoticeView.frame = CGRect(x: 110, y: 150, width: 200, height: 50)
                                            })
                                        })
                                    }
                                }, completion: {
                                    finished in
                                    UIView.animate(withDuration: 0.1) { [self] in
                                        serialQueue.asyncAfter(wallDeadline: .now() + 0.5, execute: {
                                            UIView.animate(withDuration: 0.2) { [self] in
                                                self.pushNoticeView.frame = CGRect(x: 110, y: 150, width: 200, height: 50)
                                            }
                                        })
                                        serialQueue.asyncAfter(wallDeadline: .now() + 1, execute: {
                                            UIView.animate(withDuration: 0.2) { [self] in
                                                self.pushNoticeView.frame = CGRect(x: 110, y: -20, width: 200, height: 50)
                                            }
                                        })
                                    }
                                })
                                creationLabel.text = "Ошибка соединения"
                                refreshButton.isHidden = false
                            }
                        })
                    })
                }
            })
        }
    }
    @objc func textFieldTap(tapGestureRecognizer: UITapGestureRecognizer) {
        nameTextField.becomeFirstResponder()
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [],
                                animations: {
            self.nameTextField.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.nameTextField.layer.shadowRadius = 6
            self.nameTextField.layer.shadowColor = UIColor.black.cgColor
            self.nameTextField.layer.shadowOpacity = 0.5
        }, completion: {
            finished in
        })
    }
    @objc func viewTap(tapGestureRecognizer: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [],
                                animations: {
            self.nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.nameTextField.layer.shadowRadius = 0
            self.nameTextField.layer.shadowColor = UIColor.black.cgColor
            self.nameTextField.layer.shadowOpacity = 0
        }, completion: {
            finished in
        })
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

extension NewHabitViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.placeholder = ""
    }
}
