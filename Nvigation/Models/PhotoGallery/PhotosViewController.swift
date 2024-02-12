//
//  PhotosViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.10.2023.
//

import UIKit
import iOSIntPackage
import SnapKit

final class PhotosViewController: UIViewController {
    
    var photoGallery = Photo.makeImages()
    var imageProcessor = ImageProcessor()
    
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
        acceptProcessor()
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
        photosCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
        return photoGallery.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = photoGallery[indexPath.row]
        cell.setup(with: photo)
        
        return cell
        
    }

}

extension PhotosViewController {
    
    func acceptProcessor() {
        
        let start = Date()
        
        let qos: QualityOfService = .utility
        let filter: ColorFilter = .noir
        
        imageProcessor.processImagesOnThread(
            sourceImages: photoGallery,
            filter: filter,
            qos: qos,
            completion: { [weak self] photos in
                
                self?.photoGallery = photos.compactMap{ $0 }.map{ UIImage(cgImage: $0)}
                let end = Date()
                
                DispatchQueue.main.async {
                    self?.photosCollectionView.reloadData()
                   
                    let applyTime = end.timeIntervalSince(start)
                    
                    print("With \(qos.rawValue) QOS and \(filter) filter, applying time for \(photos.count) photos is \(applyTime) seconds")
                }
            }
        )
    }
    
}


