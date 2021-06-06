//
//  DogCollectionView.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import UIKit

protocol DogCollectionViewProtocol: AnyObject {
    func setupView()
    func dogsDidLoad()
    func update(at index: IndexPath)
}

protocol DogViewControllerProtocol: AnyObject {
    func dogsCount() -> Int
    func dog(at index: IndexPath) -> Dog
    func willDisplay(at index: IndexPath)
    func endDisplay(at index: IndexPath)
}

final class DogCollectionView: UIView {
    weak var controller: DogViewControllerProtocol?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DogCell.self, forCellWithReuseIdentifier: DogCell.id)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        return cv
    }()
}

extension DogCollectionView: DogCollectionViewProtocol {
    func update(at index: IndexPath) {
        collectionView.reloadItems(at: [index])
    }
    
    func setupView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func dogsDidLoad() {
        collectionView.reloadData()
    }
}

extension DogCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controller?.dogsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogCell.id, for: indexPath) as! DogCell
        guard let controller = controller else { return cell }
        cell.config(with: controller.dog(at: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        controller?.willDisplay(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        controller?.endDisplay(at: indexPath)
    }
}

extension DogCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }
}
