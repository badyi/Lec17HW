//
//  ServiceProtocols.swift
//  Lec17DogApp
//
//  Created by badyi on 06.06.2021.
//

import Foundation

typealias GetDogsAPIResponse = Result<DogsResponse, NetworkServiceError>
typealias GetDogAPIResponse = Result<DogResponse, NetworkServiceError>

protocol DogsNetworkServiceProtocol {
    func getDogs(completion: @escaping (GetDogsAPIResponse) -> Void)
    func getDogImageURL(at indexPath: IndexPath, breed: String, subBreed: String? ,completion: @escaping (GetDogAPIResponse) -> Void) 
    func loadImage(imageUrl: String, _ indexPath: IndexPath ,completion: @escaping (Data?) -> Void)
    func cancelRequest(at indexPath: IndexPath)
}

enum CancelType {
    case urlLoad
    case imageLoad
}
