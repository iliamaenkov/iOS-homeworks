//
//  PhotosCollectionViewCell.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.10.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Elements
    
    var photo: UIImageView = {
        let photos = UIImageView()
        photos.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Setting constraints
    
    private func setupConstraints() {
        photo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setup(with image: UIImage) {
        photo.image = image
    }
}
