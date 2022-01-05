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
protocol LargeTitleDelegate: AnyObject {
    func preferLargeTitle()
}

class HabitsViewController: UIViewController, UpdateCollectionView, UINavigationControllerDelegate, LargeTitleDelegate {
    
    func preferLargeTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func reloadView() {
        collectionView.reloadData()
    }
    
    
   

    let cellID = HabitsCell()
    let proID = ProgressCell()
    
    
    private lazy var store = HabitsStore.shared
    
   public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let someView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    let someView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    let someView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(collectionView)
        view.backgroundColor = .white
        collectionView.reloadData()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Сегодня"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tap))
        self.collectionView.register(HabitsCell.self, forCellWithReuseIdentifier: cellID.identifier)
        self.collectionView.register(ProgressCell.self, forCellWithReuseIdentifier: proID.identifier)
        setUpViews()
        preferLargeTitle()
//        HabitsStore.shared.habits.removeAll()
        tabBar()
    }
    
    func setUpViews() {
        
        let constraints = [
            someView.heightAnchor.constraint(equalToConstant: 25),
            someView1.heightAnchor.constraint(equalToConstant: 1),
            
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            vc.titleDelegate = self
            let rootVC = UINavigationController(rootViewController: vc)
            rootVC.modalPresentationStyle = .overCurrentContext
            rootVC.modalTransitionStyle = .coverVertical
            present(rootVC, animated: true, completion: nil)
            
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
    
    func tabBar() {
        guard let tabBar = self.tabBarController?.tabBar else {
            return }
        collectionView.reloadData()

        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 30
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {

            return UIEdgeInsets(top: 22, left: 16, bottom: 6, right: 16)
        }
        else {

            return UIEdgeInsets(top: 18, left: 16, bottom: 12, right: 16)
        }
    }
}

