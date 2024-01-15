//
//  PhotosTableViewCell.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 16.10.2023.
//

import UIKit

final class PhotosTableViewCell: UITableViewCell {
    
    private var photos: [Photo] = []
    static let id = "PhotoTableCell"
    
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
 
        return collectionView
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    

    // MARK: - Configuration
    
    func setup(with photos: [Photo]) {
        self.photos = photos
        collectionView.reloadData()
    }
    
    // MARK: - Setting up UI
    
    private func setupUI() {
        titleView.addSubview(titleLabel)
        titleView.addSubview(arrowImage)
        contentView.addSubview(titleView)
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PhotosTableViewCell.id)
    }

    // MARK: - Setting constraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -6),
            
            arrowImage.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -12),
            arrowImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImage.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -6),
           
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.0 / 4, constant: -8)

        ])
    }

}

//MARK: PhotosTableViewCell - Extensions

extension PhotosTableViewCell: UICollectionViewDataSource {
    
    //MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, photos.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosTableViewCell.id, for: indexPath) as! PreviewCollectionViewCell
        
        let photo = photos[indexPath.item]
        cell.photo.image = UIImage(named: photo.image)
        
        return cell
    }

}

extension PhotosTableViewCell: UICollectionViewDelegate {
    
    //MARK: - UICollectionViewDelegate Methods
    
}
    
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {

    //MARK: - UICollectionViewDelegateFlowLayout Methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 4
        let spacingBetweenItems: CGFloat = 8
        let totalSpacing = (numberOfItemsPerRow) * spacingBetweenItems
        let height = (collectionView.bounds.width - totalSpacing) / 4
        let width = height
        
        return CGSize(width: width, height: height)
    }
}
