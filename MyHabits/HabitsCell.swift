//
//  HabitsCell.swift
//  MyHabits
//
//  Created by Dany on 24.12.2021.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    let identifier = "cellId"
    var cellTap: (() -> Void)?
    let textfield = NewHabitViewController().nameTextField
    private weak var delegate1: UpdateCollectionView?
    private var gesture = UITapGestureRecognizer()
    private struct SectionWords {
        let drink = ["Drink", "Water","drink","glass","Стакан","Выпить","Воды","воды","выпить","Попить"]
        let run = ["Run", "Пробежать","Run","run"]
        let watch = ["Watch", "Посмотреть","сериал","Movie","кино","Кино","movie","Series"]
        let sleep = ["Sleep", "Спать","Поспать","проспать ","спать","Проспать","поспать","sleep"]
    }
    private let wordsStorage = SectionWords()
    var habit = Habit(name: "", date: Date(),icon: "",  color: .blue)
    private let contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.shadowRadius = 3
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    private lazy var repeatLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Подряд: \(habit.trackDates.count)"
        label.textColor = UIColor(white: 2, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    private let everyDayLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(white: 2, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    private let circleView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let doneImage: UIImageView = {
        let doneImage = UIImageView()
        doneImage.contentMode = .scaleToFill
        doneImage.image = UIImage(systemName: "checkmark.circle")
        doneImage.tintColor = .white
        doneImage.image?.withTintColor(UIColor.white)
        return doneImage
    }()
    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 7
        icon.layer.masksToBounds = true
        icon.backgroundColor = .white
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        blurEffect()
        setupViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(habitTap(tapGestureRecognizer:)))
        circleView.addGestureRecognizer(tapGesture)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        contentView.layer.cornerRadius = 7
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 6, height: 4)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HabitsCell {
    private func setupViews(){
        self.contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(repeatLabel)
        self.contentView.addSubview(circleView)
        self.contentView.addSubview(everyDayLabel)
        self.contentView.layer.cornerRadius = 7
        self.contentView.addSubview(doneImage)
        self.contentView.addSubview(iconImage)
        circleView.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
        doneImage.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
        let constraints = [
            iconImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 2),
            iconImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,constant: 2),
            iconImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10),
            iconImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,constant: -2),
            iconImage.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.3),
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: everyDayLabel.topAnchor, constant: -5),
            everyDayLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            everyDayLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            everyDayLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor, constant: 15),
            everyDayLabel.bottomAnchor.constraint(equalTo: repeatLabel.topAnchor, constant: -45),
            repeatLabel.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 45),
            repeatLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            repeatLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor, constant: 15),
            repeatLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func blurEffect() {
        let blur = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blur)
        visualEffect.frame = contentView.bounds
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.layer.cornerRadius = 7
        visualEffect.layer.masksToBounds = true
        contentView.addSubview(visualEffect)
    }
    /// Настройки для привычки, логика на установку аватара
     func configure(habit: Habit) {
        self.habit = habit
        nameLabel.textColor = self.habit.color
        nameLabel.text = self.habit.name
        everyDayLabel.text = self.habit.dateString
        circleView.layer.borderColor = habit.color.cgColor
        repeatLabel.text = "Подряд: \(habit.trackDates.count)"
        if habit.isAlreadyTakenToday {
            circleView.backgroundColor = habit.color
        } else {
            circleView.backgroundColor = .white
        }
        for i in wordsStorage.drink {
            if habit.name.contains(i) {
                iconImage.image = UIImage(named: "rickDrink")
                break
            } else {
                for i in wordsStorage.run {
                    if habit.name.contains(i) {
                        iconImage.image = UIImage(named: "rickRun")
                        break
                    } else {
                        for i in wordsStorage.sleep {
                            if habit.name.contains(i) {
                                iconImage.image = UIImage(named: "rickSleep")
                                break
                            } else {
                                for i in wordsStorage.watch {
                                    if habit.name.contains(i) {
                                        iconImage.image = UIImage(named: "rickWatch")
                                        break
                                    } else {
                                        iconImage.image = UIImage(named: "1")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// Анимация выполнения привычки
    @objc func habitTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let serialQueue = DispatchQueue.main
        serialQueue.async {
            if self.habit.isAlreadyTakenToday {
                print("Выполнена")
            } else {
                UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [],
                                        animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                        HabitsStore.shared.track(self.habit)
                        self.circleView.backgroundColor = self.habit.color
                        self.circleView.frame = CGRect(x: self.contentView.frame.width - 70, y: 20, width: 60, height: 60)
                        self.doneImage.frame = CGRect(x: self.contentView.frame.width - 70, y: 20, width: 60, height: 60)
                        self.circleView.layoutIfNeeded()
                        self.circleView.layer.cornerRadius = 30
                    }
                }, completion: {
                    finished in
                    UIView.animate(withDuration: 0.5) { [self] in
                        circleView.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
                        doneImage.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
                        self.circleView.layer.cornerRadius = 20
                    }
                })
            }
        }
        serialQueue.asyncAfter(deadline: .now() + 0.4, execute: {
            self.cellTap?()
        })
    }
}


