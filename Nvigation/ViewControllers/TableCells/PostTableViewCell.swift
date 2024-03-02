//
//  PostTableViewCell.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 15.10.2023.
//

import UIKit
import StorageService

final class PostTableViewCell: UITableViewCell {
    
    static let id = "PostCell"
    
    // MARK: - UI Elements
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var descriptionText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func setupUI() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(descriptionText)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
    }
    
    func setup(with post: Post) {
        authorLabel.text = post.author
        descriptionText.text = post.description
        postImageView.image = UIImage(named: post.image ?? "Empty")
        likesLabel.text = "Likes: \(post.likes + post.likeCount)"
        viewsLabel.text = "Views: \(post.views)"
    }
    
    // MARK: - Setting constraints
    
    private func setupConstraints() {
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.top.equalTo(contentView).offset(16)
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(postImageView.snp.width)
        }
        descriptionText.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionText.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
        }
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionText.snp.bottom).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
}
