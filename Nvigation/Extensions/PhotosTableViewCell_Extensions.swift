//
//  PhotosTableViewCell_Extensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 19.10.2023.
//

import UIKit

//MARK: PhotosTableViewCell - Extensions

extension PhotosTableViewCell: UICollectionViewDataSource {
    
    //MARK: - UICollectionViewDataSource Methods
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return min(4, photos.count)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosTableViewCell.id,
            for: indexPath
        ) as! PreviewCollectionViewCell
        
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

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 4
        let spacingBetweenItems: CGFloat = 8
        let totalSpacing = (numberOfItemsPerRow) * spacingBetweenItems
        let height = (collectionView.bounds.width - totalSpacing) / 4
        let width = height
        
        return CGSize(width: width, height: height)
    }
}
