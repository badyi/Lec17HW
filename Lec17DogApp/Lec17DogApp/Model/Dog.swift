//
//  DogModel.swift
//  Lec17DogApp
//
//  Created by badyi on 06.06.2021.
//

import Foundation

final class Dog {
    var breed: String
    var subBreed: String?
    var url: String?
    var imageData: Data?
    
    init(_ breed: String, _ subBreed: String? = nil) {
        self.breed = breed
        self.subBreed = subBreed
    }
}
