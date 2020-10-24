//
//  NetworkManager.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

import Alamofire

enum ClientError: Error {
    case clientError(Data?)
    case reponseError
    case serverError
    case unexpectedError(Error?)
}

class NetworkManager {
    
    func request(
//        path: String,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        let path = "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss"
        URLSession.shared.dataTask(with: makeRequest(path: path), completionHandler: { (data, response, error) in
            guard error == nil else {
                return completion(.failure(ClientError.unexpectedError(error)))
            }
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(ClientError.reponseError))
            }
            
            let httpResponse = response
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200..<300:
                print(data as Any)
                
                completion(.success(data))
            
            case 400..<500:
                
                completion(.failure(ClientError.clientError(data)))
                
            case 500..<600:
                
                completion(.failure(ClientError.serverError))
            
            default: return
            
                completion(.failure(ClientError.unexpectedError(nil)))
                
            }
            
        }).resume()
        
    }

    private func makeRequest(path: String) -> URLRequest {
        let url = URL(string: path)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
        
    }
}
