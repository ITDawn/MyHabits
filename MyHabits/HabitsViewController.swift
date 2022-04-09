//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Dany on 07.10.2021.
//

import UIKit

protocol UpdateCollectionView: AnyObject {
    func reloadView()
}

class HabitsViewController: UIViewController, UpdateCollectionView, UINavigationControllerDelegate  {
    
    let details = DetailViewController()
    
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    
    
    
    let cellID = HabitsCell()
    let proID = ProgressCell()
    
     
    private lazy var store = HabitsStore.shared
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(patternImage: UIImage(named: "44")!)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        print(self.view.frame.width)
//                HabitsStore.shared.habits.removeAll()
        tabBar()
    }
    
    
    func setUpViews() {
        
        details.delegate1 = self
        view.addSubview(backGroundView)
        backGroundView.addSubview(collectionView)
        self.view.backgroundColor = .white
        collectionView.reloadData()
        self.navigationItem.title = "Сегодня"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tap))
        self.collectionView.register(HabitsCell.self, forCellWithReuseIdentifier: cellID.identifier)
        self.collectionView.register(ProgressCell.self, forCellWithReuseIdentifier: proID.identifier)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.alpha = 0.4
        let constraints = [
            backGroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: backGroundView.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    private enum Section {
        case Progress, Habits, Unknown
        
        init(section: Int){
            switch section {
            case 0:
                self = .Progress
            case 1:
                self = .Habits
            default:
                self = .Unknown
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            let habit = store.habits[indexPath.item]
            let vc = DetailViewController()
            vc.habit = habit
            vc.delegate1 = self
            vc.titleDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func tap() {
        let vc = NewHabitViewController()
        vc.delegate1 = self
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.modalPresentationStyle = .overCurrentContext
        rootVC.modalTransitionStyle = .crossDissolve
        present(rootVC, animated: true, completion: nil)
        
    }
    /// Настройка табБара
    func tabBar() {
        guard let tabBar = self.tabBarController?.tabBar else {
            return }
        if self.view.frame.width > 500 {
            tabBar.frame = CGRect(x: 2, y: 3, width: 300, height: 200)
            tabBar.layer.cornerRadius = tabBar.frame.height * 0.5

        } else {
            tabBar.frame = CGRect(x: self.view.frame.width * 0.021, y: self.view.frame.height * 0.883, width: self.view.frame.width * 0.96, height: self.view.frame.height * 0.11)
            tabBar.layer.cornerRadius = tabBar.frame.height * 0.4

        }
       
        tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "22")!)
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
       
        
        
       
    }
    
}
extension HabitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
            return 1
        } else {
            
            return store.habits.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: proID.identifier, for: indexPath) as! ProgressCell
            cell.setupUI()
            return cell
        } else {
            let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID.identifier, for: indexPath) as! HabitsCell
            let habit = store.habits[indexPath.item]
            
            habitCell.configure(habit: habit)
            habitCell.cellTap = { [weak self] in
                self?.collectionView.reloadData()
            }
            return habitCell
        }
    }
    
}


extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            
            return .init(width: (UIScreen.main.bounds.width - 32), height: 60)
        }
        else {
            
            return .init(width: (UIScreen.main.bounds.width - 32), height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            
            return UIEdgeInsets(top: 22, left: 16, bottom: 6, right: 16)
        }
        else {
            
            return UIEdgeInsets(top: 22, left: 16, bottom: 16, right: 16)
        }
    }
}

