//
//  PhotosViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.10.2023.
//

import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {

    let facade = ImagePublisherFacade()
    
    var galleryImages: [UIImage] = []
    var photoGallery = Photo.makeImages()
    
    // MARK: Visual objects
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    lazy var photosCollectionView: UICollectionView = {
        let photos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.backgroundColor = .white
        photos.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return photos
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        
        facade.subscribe(self)
        facade.addImagesWithTimer(time: 0.5, repeat: 20, userImages: photoGallery)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        facade.removeSubscription(for: self)
    }
    
    override func viewWillTransition(
        to size: CGSize, 
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else {
                return
            }
            
            self.photosCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: { context in })
    }

    
    
   //MARK: - Private
    
    private func setupUI() {
        title = "Photo Gallery"
        view.addSubview(photosCollectionView)
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
    }
    
    // MARK: - Setting constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.isNavigationBarHidden = false

    }
}

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


