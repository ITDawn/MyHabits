//
//  ProgressCell.swift
//  MyHabits
//
//  Created by Dany on 24.12.2021.
//

import UIKit

class ProgressCell: UICollectionViewCell {
    let identifier = "proID"
    
    func setupUI() {
        progressSlider.setValue(HabitsStore.shared.todayProgress, animated: true)
        percentLabel.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
    }
    
    var letsGoLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Все получится"
        label.textColor = .white
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
        label.textColor = .white
        label.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        blurEffect()
        setupViews()
    }
    
    
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        self.contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
        setupViews()
        blurEffect()
    }
    
    func blurEffect() {
        let blur = UIBlurEffect(style: .regular)
        let visualEffect = UIVisualEffectView(effect: blur)
        visualEffect.frame = contentView.bounds
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.layer.cornerRadius = 7
        visualEffect.layer.masksToBounds = true
        contentView.addSubview(visualEffect)
    }
    
    func setupViews() {
        self.contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
        self.contentView.layer.shadowOffset = CGSize(width: 6, height: 4)
        self.contentView.layer.shadowRadius = 5
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.7
        self.contentView.layer.cornerRadius = 7
        
        self.contentView.addSubview(letsGoLabel)
        self.contentView.addSubview(progressSlider)
        self.contentView.addSubview(percentLabel)
        
        let constraints = [
            
            letsGoLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            letsGoLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            letsGoLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            
            progressSlider.topAnchor.constraint(equalTo: letsGoLabel.bottomAnchor, constant: 10),
            progressSlider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            progressSlider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            progressSlider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            percentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
