//
//  ProgressTableViewCell.swift
//  MyHabits
//
//  Created by Dany on 20.12.2021.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    let identifier = "proID"
    var letsGoLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Все получится"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private var progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setValue(HabitsStore.shared.todayProgress, animated: true)
        slider.tintColor = .systemPurple
        
        return slider
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        label.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        
        self.contentView.addSubview(letsGoLabel)
        self.contentView.addSubview(progressSlider)
        self.contentView.addSubview(percentLabel)

        let constraints = [
        
            letsGoLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            letsGoLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            letsGoLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            letsGoLabel.heightAnchor.constraint(equalToConstant: 15),
            
            progressSlider.topAnchor.constraint(equalTo: letsGoLabel.bottomAnchor, constant: 10),
            progressSlider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            progressSlider.heightAnchor.constraint(equalToConstant: 10),
            progressSlider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            progressSlider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            percentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            percentLabel.heightAnchor.constraint(equalToConstant: 15)

        ]
        NSLayoutConstraint.activate(constraints)
    }
}
