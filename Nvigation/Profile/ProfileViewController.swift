//
//  ProfileViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    
    private lazy var profileHeaderView: ProfileHeaderView = { [weak self] in
        guard let self = self else { return ProfileHeaderView() }
        let profileHeaderView = ProfileHeaderView()

        return profileHeaderView
    }()
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.view.backgroundColor = .lightGray
        
        view.addSubview(profileHeaderView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileHeaderView.frame = view.bounds
    }
}
