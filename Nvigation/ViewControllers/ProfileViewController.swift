//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import CoreData

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
    
    private let coreDataService = CoreDataService.shared
    private var viewModel: ProfileViewModel
    var user: User?
    var profileHeader = ProfileHeaderView()
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
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
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
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
        profileHeader.user = viewModel.currentUser
        profileHeader.profileVC = self
    }
    
    private func tuneTableView() {
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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
            addDoubleTapGesture(to: cell)
            
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


extension ProfileViewController: UIGestureRecognizerDelegate {

    private func addDoubleTapGesture(to cell: UITableViewCell) {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapOnPost(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        cell.addGestureRecognizer(doubleTapGesture)
    }

    @objc func handleDoubleTapOnPost(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else {
            return
        }
        let touchPoint = recognizer.location(in: tableView)

        if let indexPath = tableView.indexPathForRow(at: touchPoint), indexPath.section == 1 {
            let postIndex = indexPath.row
            let postToSave = posts[postIndex]

            if coreDataService.isPostSaved(postToSave) {
                print("Post with ID \(postToSave.id) is already saved.")
                return
            }
            coreDataService.savePostInBackground(postToSave)
            coreDataService.setPostLikedStatus(postIndex, isLiked: true)
            showHeartAnimation(at: indexPath)
            tableView.reloadData()
        }
    }

    private func showHeartAnimation(at indexPath: IndexPath) {
        let systemNameImage = "heart.fill"

        let heartImageView = UIImageView(image: UIImage(systemName: systemNameImage))
        heartImageView.tintColor = .red
        heartImageView.frame = CGRect(x: 0, y: 0, width: 65, height: 50)
        heartImageView.center = tableView.cellForRow(at: indexPath)?.center ?? view.center

        tableView.addSubview(heartImageView)

        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: heartImageView.center.x - 5, y: heartImageView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: heartImageView.center.x + 5, y: heartImageView.center.y))
        heartImageView.layer.add(shakeAnimation, forKey: "position")

        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveEaseOut, animations: {
            heartImageView.alpha = 0
        }) { _ in
            heartImageView.removeFromSuperview()
        }
    }
}

