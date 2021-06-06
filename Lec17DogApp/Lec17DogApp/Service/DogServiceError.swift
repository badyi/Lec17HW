//
//  DogServiceError.swift
//  Lec17DogApp
//
//  Created by badyi on 06.06.2021.
//

import Foundation

enum NetworkServiceError: Error {
    case unauthorize
    case network
    case decodable
    case unknown
}
