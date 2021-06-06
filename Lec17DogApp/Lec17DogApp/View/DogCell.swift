//
//  DogCell.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import UIKit

final class DogCell: UICollectionViewCell {
    static let id = "DogCell"
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(21)
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
        imageView.image = nil
    }
}

extension DogCell {
    func config(with dog: Dog) {
        label.text = dog.breed + " " + (dog.subBreed ?? "")
        indicator.startAnimating()
        guard let imageData = dog.imageData else { return }
        imageView.image = UIImage(data: imageData)
        indicator.stopAnimating()
    }
}

extension DogCell {
    private func setupView() {
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.addSubview(indicator)
        indicator.startAnimating()
        indicator.color = .systemBlue
        label.textColor = .black
        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            indicator.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            indicator.topAnchor.constraint(equalTo: imageView.topAnchor),
            indicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            indicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}
