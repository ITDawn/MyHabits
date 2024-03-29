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
    private let details = DetailViewController()
    private let cellID = HabitsCell()
    private let proID = ProgressCell()
    private let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "44")!)
        return view
    }()
    
    private let pushNoticeView: UIView = {
        let view = UIView(frame: CGRect(x: 110, y: -20, width: 200, height: 50))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemPink
        return view
    }()
    private let noticeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: 45))
        label.text = "ЗАЕБИСЬ"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var store = HabitsStore.shared
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        print(self.view.frame.width)
                        HabitsStore.shared.habits.removeAll()
        tabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillLayoutSubviews() {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    internal func reloadView() {
        let serialQueue = DispatchQueue.main
        self.collectionView.reloadData()

        serialQueue.asyncAfter(deadline: .now() + 2, execute: {
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
                            self.navigationController!.navigationBar.layer.zPosition = 0
                            self.tabBarController?.tabBar.layer.zPosition = 0
//                            self.tabBarController?.tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "22")!)

                            self.navigationController?.navigationBar.backgroundColor = .white
 
                        }

                    })
                }
            })


        })
        
        
    }
    private func setUpViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        details.delegate1 = self
        view.addSubview(backGroundView)
        view.addSubview(pushNoticeView)
        pushNoticeView.addSubview(noticeLabel)
        backGroundView.addSubview(collectionView)
        self.view.backgroundColor = .white
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
    /// Настройка табБара
    private func tabBar() {
        guard let tabBar = self.tabBarController?.tabBar else {
            return }
        if self.view.frame.width > 500 {
            tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "33")!)
        } else {
            tabBar.frame = CGRect(x: self.view.frame.width * 0.021, y: self.view.frame.height * 0.883, width: self.view.frame.width * 0.96, height: self.view.frame.height * 0.11)
            tabBar.layer.cornerRadius = tabBar.frame.height * 0.4
            tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "22")!)
            tabBar.layer.masksToBounds = true
            tabBar.layer.borderWidth = 1
            tabBar.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        }
    }
    
    @objc func tap() {
        let vc = NewHabitViewController()
        vc.delegate1 = self
        navigationController?.pushViewController(vc, animated: true)

//        let rootVC = UINavigationController(rootViewController: vc)
//        rootVC.modalPresentationStyle = .overCurrentContext
//        rootVC.modalTransitionStyle = .crossDissolve
//        present(rootVC, animated: true, completion: nil)
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

