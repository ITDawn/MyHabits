//
//  HabitsTableViewCell.swift
//  MyHabits
//
//  Created by Dany on 14.12.2021.
//

import UIKit

class HabitsTableViewCell: UITableViewCell {
    let identifier = "cellId"

    var cellTap: (() -> Void)?

    var gesture = UITapGestureRecognizer()
    var habit = Habit(name: "", date: Date(), color: .red)

    let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    lazy var repeatLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Подряд: \(habit.trackDates.count)"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let everyDayLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .black
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
        doneImage.isHidden = true
        doneImage.translatesAutoresizingMaskIntoConstraints = false
        return doneImage
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        gesture = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        circleView.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupViews()
    }
    
}



extension HabitsTableViewCell {
     func setupViews(){
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(repeatLabel)
        self.contentView.addSubview(circleView)
        self.contentView.addSubview(everyDayLabel)
        circleView.addSubview(doneImage)


        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            
            circleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            circleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            circleView.heightAnchor.constraint(equalToConstant: 40),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            
            everyDayLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            everyDayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            everyDayLabel.heightAnchor.constraint(equalToConstant: 15),
            
            repeatLabel.topAnchor.constraint(equalTo: everyDayLabel.bottomAnchor, constant: 50),
            repeatLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            repeatLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            repeatLabel.heightAnchor.constraint(equalToConstant: 20),
            
            doneImage.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            doneImage.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            doneImage.heightAnchor.constraint(equalToConstant: 45),
            doneImage.widthAnchor.constraint(equalTo: doneImage.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
     }
    func configure(habit: Habit) {
        self.habit = habit
        
        if habit.isAlreadyTakenToday {
            circleView.backgroundColor = habit.color
        }
        
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
        
    }
    @objc func viewPressed() {
        if habit.isAlreadyTakenToday {
            print("Привычка")
        } else {
            doneImage.isHidden = false
            HabitsStore.shared.track(habit)
            circleView.backgroundColor = habit.color
        }
        cellTap?()
    }
}

