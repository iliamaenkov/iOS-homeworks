//
//  Exyensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 13.10.2023.
//
import UIKit

//MARK: - LogInViewController Extensions

extension LogInViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - ProfileViewController Extensions

extension ProfileViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate Methods
    
    // Returns the dynamic height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Provides a custom view for the table view section header.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileHeaderView()

        return headerView
    }
    
    // Specifies the height of the section header in the table view.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource Methods
    
    // Returns the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the number of rows in the table view, which is based on the number of posts.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Configures and returns a cell for a given row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        
        return cell
    }
}
