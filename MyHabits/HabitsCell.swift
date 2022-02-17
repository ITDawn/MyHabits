//
//  HabitsCell.swift
//  MyHabits
//
//  Created by Dany on 24.12.2021.
//

import UIKit

class HabitsCell: UICollectionViewCell {
    let identifier = "cellId"
    let textfield = NewHabitViewController().nameTextField
    var cellTap: (() -> Void)?
    
    var gesture = UITapGestureRecognizer()
    
    struct SectionWords {
        let drink = ["Drink", "Water","drink","glass","Стакан","Выпить","Воды","воды","выпить","Попить"]
        let run = ["Run", "Пробежать"]
        let watch = ["Watch", "Посмотреть","сериал","Movie","кино","Кино","movie","Series"]
        let sleep = ["Sleep", "Спать","Поспать","проспать ","спать","Проспать","поспать","sleep"]
    }
   let wordsStorage = SectionWords()
    
    var habit = Habit(name: "", date: Date(),icon: "",  color: .red)
    
     
    let contView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var repeatLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Подряд: \(habit.trackDates.count)"
        label.textColor = UIColor(white: 2, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let everyDayLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(white: 2, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneImage: UIImageView = {
        let doneImage = UIImageView()
        doneImage.contentMode = .scaleToFill
        doneImage.image = UIImage(systemName: "checkmark.circle")
        doneImage.tintColor = .white
        doneImage.image?.withTintColor(UIColor.white)
        //        doneImage.translatesAutoresizingMaskIntoConstraints = false
        return doneImage
    }()
    
    var heightAndWidthConstraint: NSLayoutConstraint! = nil
    
    let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 7
        icon.layer.masksToBounds = true
        icon.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        icon.backgroundColor = .white
        icon.alpha = 0.9
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 6, height: 4)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.7
        setupViews()
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(habitTap(tapGestureRecognizer:)))
       

        circleView.addGestureRecognizer(tapGesture)
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        
        contentView.layer.cornerRadius = 7
}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
       
      
        contentView.layer.cornerRadius = 7
        setupViews()
    }
}


extension HabitsCell {
    func setupViews(){
        self.contentView.backgroundColor = UIColor(white: 0.8, alpha: 0.6)
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
            
            iconImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            iconImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            iconImage.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -10),
            iconImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: everyDayLabel.topAnchor, constant: -5),
            //
            //            circleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            //            circleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            //            circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor),
            
            everyDayLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            everyDayLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            everyDayLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor, constant: 15),
            everyDayLabel.bottomAnchor.constraint(equalTo: repeatLabel.topAnchor, constant: -45),
            
            repeatLabel.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 45),
            repeatLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            repeatLabel.trailingAnchor.constraint(equalTo: doneImage.leadingAnchor, constant: 15),
            repeatLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            //            doneImage.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            //            doneImage.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            //            doneImage.heightAnchor.constraint(equalToConstant: 45),
            //            doneImage.widthAnchor.constraint(equalTo: doneImage.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
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
            print("красавчик")
            iconImage.image = UIImage(named: "rickDrink")
            break
        } else {
            iconImage.image = UIImage(named: "1")

        }
            for i in wordsStorage.run {
                if habit.name.contains(i) {
                    iconImage.image = UIImage(named: "rickRun")
                    break
                } else {
                    iconImage.image = UIImage(named: "1")
                }
            }
            
            for i in wordsStorage.sleep {
                if habit.name.contains(i) {
                    iconImage.image = UIImage(named: "rickSleep")
                    break
                } else {
                    iconImage.image = UIImage(named: "1")

                }
            }
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
  
    
    /// Анимация выполнения привычки
    @objc func habitTap(tapGestureRecognizer: UITapGestureRecognizer) {
       

        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [],
                                animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                if self.habit.isAlreadyTakenToday {
                    print("Habit is already taken today")
                } else {
                    HabitsStore.shared.track(self.habit)
                    
                    self.circleView.backgroundColor = self.habit.color
                    self.circleView.frame = CGRect(x: self.contentView.frame.width - 70, y: 20, width: 60, height: 60)
                    self.doneImage.frame = CGRect(x: self.contentView.frame.width - 70, y: 20, width: 60, height: 60)
                    self.circleView.layoutIfNeeded()
                    self.circleView.layer.cornerRadius = 30
                }
            }

        }, completion: {
            finished in
            
            UIView.animate(withDuration: 0.5) { [self] in
                circleView.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
                doneImage.frame = CGRect(x: self.contentView.frame.width - 60, y: 50, width: 40, height: 40)
                
                self.circleView.layer.cornerRadius = 20

            }
        })
        if self.circleView.backgroundColor != .white {
           cellTap?()
        }

    }
}


