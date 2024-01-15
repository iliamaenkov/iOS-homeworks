//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

protocol ProfileVIewControllerDelegate: AnyObject {
    func scrollOn()
    func scrollOff()
}

extension ProfileViewController: ProfileVIewControllerDelegate {

    func scrollOn() {
        self.tableView.isScrollEnabled = true
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
    }
    
    func scrollOff() {
        self.tableView.isScrollEnabled = false
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
    }
}

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel
    var user: User?
    var profileHeader = ProfileHeaderView()
    
    // MARK: - Init
    
    init(user: User?, viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        
        return tableView
    }()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuneTableView()
        setupConstraints()
        setupHeader()
        bindViewModel()
        
#if DEBUG
        tableView.backgroundColor = .systemRed
#else
        tableView.backgroundColor = .systemGray6
#endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.beginAppearanceTransition(true, animated: true)
          self.endAppearanceTransition()
    
          navigationController?.setNavigationBarHidden(true, animated: true)
      }
    
//    override func viewDidAppear(_ animated: Bool) {
//        Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
//            self.showBreakScreen()
//        })
//    }
    
    //MARK: - Private
    
    private func bindViewModel() {
        viewModel.currentState = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                print("initial")
            case .loading:
                print("loading")
            case .loaded(let user):
                self.user = user
                tableView.reloadData()
                print("loaded loaded")
            case .error:
                print("error")
            }
            
        }
    }

    
    private func setupHeader() {
        profileHeader.user = user
        profileHeader.profileVC = self
    }
    
    private func tuneTableView() {
        
        view.addSubview( tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func showBreakScreen() {
        let breakScreen = BreakScreenViewController()
        
        breakScreen.modalTransitionStyle = .coverVertical
        breakScreen.modalPresentationStyle = .pageSheet
        
        present(breakScreen, animated: true)
    }
}

//MARK: - ProfileViewController Extensions

extension ProfileViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? profileHeader : nil
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.id, for: indexPath) as! PhotosTableViewCell
            
            cell.setup(with: photos)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            
            let post = posts[indexPath.row]
            cell.setup(with: post)
            return cell
        }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.showPhotoGallery?()
        }
    }

}
