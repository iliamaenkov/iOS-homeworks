//
//  PhotosViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.10.2023.
//

import UIKit
import iOSIntPackage

// MARK: - PhotosViewController Extensions

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    //MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 3
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = (accessibleWidth / countItem)
        
        return CGSize(width: widthItem, height: widthItem)
    }
    
}

extension PhotosViewController: UICollectionViewDataSource {

    // MARK: UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let image = galleryImages[indexPath.item]
        cell.setup(with: image)
        return cell
        
    }

}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        galleryImages = images
        photosCollectionView.reloadData()
    }
}
