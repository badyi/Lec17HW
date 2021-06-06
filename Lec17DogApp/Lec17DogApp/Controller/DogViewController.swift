//
//  ViewController.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import UIKit

final class DogViewController: UIViewController {
    private var myView: DogCollectionViewProtocol
    private let networkService: DogsNetworkServiceProtocol
    private var dogs: [Dog]
    
    init(with view: DogCollectionViewProtocol, _ networkService:  DogsNetworkServiceProtocol) {
        self.myView = view
        self.networkService = networkService
        dogs = [Dog]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = (myView as! UIView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.setupView()
        loadDogs()
    }
}

extension DogViewController {
    func loadDogs() {
        networkService.getDogs { [weak self] result in
            switch result {
            case let .success(dogs):
                let dogsDictinary: [String: [String]] = dogs.message
                let list = dogsDictinary.reduce(into: [Dog]()) { result, element in
                    if element.value == [] {
                        result.append(Dog(element.key))
                    } else {
                        element.value.forEach {
                            result.append(Dog(element.key, $0))
                        }
                    }
                }
                self?.dogs = list
                DispatchQueue.main.async { [weak self] in
                    self?.myView.dogsDidLoad()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension DogViewController: DogViewControllerProtocol {
    func willDisplay(at index: IndexPath) {
        loadImageURL(at: index)
    }
    
    func endDisplay(at index: IndexPath) {
        networkService.cancelRequest(at: index)
    }
    
    func dogsCount() -> Int {
        dogs.count
    }
    
    func dog(at index: IndexPath) -> Dog {
        dogs[index.row]
    }
}

extension DogViewController {
    func loadImageURL(at index: IndexPath) {
        let dog = dogs[index.row]
        if let url = dog.url {
            loadImage(at: index, with: url)
            return
        }
        networkService.getDogImageURL(at: index, breed: dog.breed, subBreed: dog.subBreed) { [weak self] result in
            switch result {
            case let .success(urls):
                let url = urls.message.first
                self?.loadImage(at: index, with: url)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loadImage(at index: IndexPath, with url: String?) {
        let dog = dogs[index.row]
        if let image = dog.imageData { return }
        
        guard let url = url else { return }
        networkService.loadImage(imageUrl: url, index) { [weak self] result in
            if result != nil {
                dog.imageData = result
                DispatchQueue.main.async {
                    self?.myView.update(at: index) 
                }
            } else {
                print("image load fail")
            }
        }
    }
}
