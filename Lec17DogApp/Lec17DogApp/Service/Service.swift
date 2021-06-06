//
//  Service.swift
//  Lec17DogApp
//
//  Created by badyi on 05.06.2021.
//

import Foundation

final class Cancel {
    var imageURLLoad: URLSessionDataTask?
    var imageLoad: URLSessionDataTask?
    
    init(imageURLLoad: URLSessionDataTask) {
        self.imageURLLoad = imageURLLoad
    }
}

final class DogsNetworkService {
    private let session: URLSession = .shared
    private var tasks: [IndexPath: Cancel] = [:]
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private var authorizeResponse: DogsResponse?
}

extension DogsNetworkService: DogsNetworkServiceProtocol {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func getDogs(completion: @escaping (GetDogsAPIResponse) -> Void) {
        // request
        let components = URLComponents(string: Constants.DogsApiMethods.getDogs)
        
        guard let url = components?.url else {
            completion(.failure(.unknown))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // handler
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = try self.decoder.decode(DogsResponse.self, from: data)
                completion(.success(response))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }

        // call
        session.dataTask(with: request, completionHandler: handler).resume()
    }

    func loadImage(imageUrl: String, _ indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        // request
        if tasks[indexPath] != nil && tasks[indexPath]?.imageLoad != nil {
            return
        }
        let imageUrlWithSize = imageUrl.replacingOccurrences(of: "{width}x{height}", with: "375x880")
        guard let url = URL(string: imageUrlWithSize) else { completion(nil); return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        // hadler
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                completion(data)
            } catch {
                completion(nil)
            }
            self.endRequest(at: indexPath, type: .imageLoad)
        }
        
       
        // call
        let dataTask = session.dataTask(with: request, completionHandler: handler)
        tasks[indexPath]?.imageLoad = dataTask
        dataTask.resume()
    }
    
    func getDogImageURL(at indexPath: IndexPath, breed: String, subBreed: String? ,completion: @escaping (GetDogAPIResponse) -> Void) {
        
        if tasks[indexPath] != nil && tasks[indexPath]?.imageURLLoad != nil {
            return
        }
        // request
        let components = URLComponents(string: Constants.DogsApiMethods.getDogImageURL)

        guard var url = components?.url else {
            completion(.failure(.unknown))
            return
        }
        url = url.appendingPathComponent(breed)
        if subBreed != nil {
            url = url.appendingPathComponent(subBreed!)
        }
        url = url.appendingPathComponent("images")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // handler
        let handler: Handler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = try self.decoder.decode(DogResponse.self, from: data)
                completion(.success(response))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
            self.endRequest(at: indexPath, type: .urlLoad)
        }

        // call
        let dataTask = session.dataTask(with: request, completionHandler: handler)
        let cancel = Cancel(imageURLLoad: dataTask)
        tasks[indexPath] = cancel
        dataTask.resume()
    }

    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.network
        }
        return data
    }
    
    func cancelRequest(at indexPath: IndexPath) {
        let tasks = self.tasks[indexPath]
        tasks?.imageLoad?.cancel()
        tasks?.imageURLLoad?.cancel()
        
        tasks?.imageLoad = nil
        tasks?.imageURLLoad = nil
    }
    
    private func endRequest(at indexPath: IndexPath, type: CancelType) {
        let task = self.tasks[indexPath]
        task?.imageLoad = nil
        task?.imageURLLoad = nil
    }
}
