//
//  CannelProvider.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/25.
//

import Foundation

let ChannelRssFeedKey = "PPBaseRSSFeed"

class ChannelProvider {
    
    private var item: ChannelItem?
    
    func getChannelItem(completion: @escaping (Result<ChannelItem, Error>) -> Void) {
        if let item = item {
            return completion(.success(item))
        }
        
        queryChannelItem(completion: completion)
    }
    
    private func queryChannelItem(completion: @escaping (Result<ChannelItem, Error>) -> Void) {
        guard let urlPath = Bundle.ValueForString(key: ChannelRssFeedKey) else {
            return completion(.failure(ParserError.urlNotFound))
        }
        
        getItem(withPath: urlPath) { result in
            switch result {
            case .failure(let error):
                print("Query error: \(error)")
                completion(.failure(error))
                
            case .success(let item):
                self.item = item
                completion(.success(item))
            }
        }
    }
    
    private func getItem(
        withPath urlString: String,
        completion: @escaping (Result<ChannelItem, Error>) -> Void
    ) {
        
        let parser = RSSParser()
        parser.request(urlPath: urlString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            
            case .success(let rssFeed):
                guard let item = parser.parseRssFeed(rssFeed) else {
                    return completion(.failure(ParserError.parserDataFail))
                }
                
                completion(.success(item))
            }
        }
    }
}
