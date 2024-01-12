//
//  PhotosCollectionViewCell.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.10.2023.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    var photo: UIImageView = {
        let photos = UIImageView()
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.clipsToBounds = true
        photos.layer.cornerRadius = 6
        
        return photos
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setting constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

