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
        titleView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(collectionView.snp.top)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleView).offset(12)
            make.top.equalTo(titleView).offset(6)
            make.bottom.equalTo(titleView).offset(-6)
        }
        arrowImage.snp.makeConstraints { make in
            make.trailing.equalTo(titleView).offset(-12)
            make.centerY.equalTo(titleLabel)
            make.bottom.equalTo(titleView).offset(-6)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(12)
            make.trailing.equalTo(contentView).offset(-12)
            make.top.equalTo(titleView.snp.bottom)
            make.bottom.equalTo(contentView).offset(-12)
            make.height.equalTo(collectionView.snp.width).multipliedBy(1.0 / 4).offset(-8)
        }
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
