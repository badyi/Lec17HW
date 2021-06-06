//
//  ServiceModel.swift
//  Lec17DogApp
//
//  Created by badyi on 06.06.2021.
//

import Foundation

struct DogsResponse: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogResponse: Codable {
    let message: [String]
    let status: String
}
