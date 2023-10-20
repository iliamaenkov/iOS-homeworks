//
//  PhotosTableViewCell.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 16.10.2023.
//

import UIKit

final class PhotosTableViewCell: UITableViewCell {
    
    private var photos: [Photo] = []
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell") // Register cell here
        
        return collectionView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos"
        
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.forward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        arrow.widthAnchor.constraint(equalToConstant: 24).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrow.contentMode = .scaleAspectFit
        return arrow
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
    
    func setup(with photos: [Photo]) {
        self.photos = photos
        collectionView.reloadData()
    }
    
    // MARK: - Setting up UI
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(arrowImage)
        addSubview(collectionView)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Setting constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImage.leadingAnchor, constant: -12),
            
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            arrowImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImage.widthAnchor.constraint(equalToConstant: 40),
            arrowImage.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

