//
//  ProfileViewController_Extensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 19.10.2023.
//

import UIKit

//MARK: - ProfileViewController Extensions

extension ProfileViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate Methods

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return section == 0 ? ProfileHeaderView() : nil
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
         return section == 0 ? 220 : 0
     }
}

extension ProfileViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 2
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return section == 0 ? 1 : posts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PhotosCell",
                for: indexPath
            ) as! PhotosTableViewCell
            
            cell.setup(with: photos)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PostCell",
                for: indexPath
            ) as! PostTableViewCell
            
            let post = posts[indexPath.row]
            cell.setup(with: post)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.section == 0 {
            let photosViewController = PhotosViewController()
            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
    }

}
