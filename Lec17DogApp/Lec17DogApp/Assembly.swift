//
//  Assembly.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import Foundation

final class MainAssembly {
    static func createMainModule() -> DogViewController? {
        let view = DogCollectionView()
        let service = DogsNetworkService()
        let viewController = DogViewController(with: view, service)
        view.controller = viewController
        return viewController
    }
}
