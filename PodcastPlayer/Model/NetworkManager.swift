//
//  NetworkManager.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

import FeedKit

enum ClientError: Error {
    case urlNotFound
    case rssFeedNotFound
    case clientError(Data?)
    case reponseError
    case serverError
    case unexpectedError(Error?)
}

class RSSParser {
    func request(
        urlPath: String,
        completion: @escaping (Result<ChannelItem, Error>) -> Void
    ) {
        guard let url = URL(string: urlPath) else { return }
        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("ERROR \(error)")
                    completion(.failure(error))
                case .success(let feed):
                    switch feed {
                    case .rss(let rss):
                        let item = ChannelItemBuilder.parserRssFeed(rss)
                        completion(.success(item))
                    default:
                        completion(.failure(ClientError.reponseError))
                    }
                }
            }
        }
    }
}

class ChannelItemBuilder {
    static func parserRssFeed(_ feed: RSSFeed) -> ChannelItem {
        let channelTitle = feed.title // 科技島讀
        let channelImageURLPath = feed.image?.url // String
        
        guard let items = feed.items else {
            let channelItem = ChannelItem(title: channelTitle, imageURLString: channelImageURLPath, items: [])
            return channelItem
        }
    
        var episodeItems: [EpisodeItem] = []
        
        for item in items {
            let title = item.title
            let link = item.link
            let description = item.description
            let pubDate = item.pubDate
            let imageURLPath = item.iTunes?.iTunesImage?.attributes?.href
            let episodeItem = EpisodeItem(title: title, pubDate: pubDate, link: link, description: description, imageURLPath: imageURLPath)
            episodeItems.append(episodeItem)
        }
        
        let channelItem = ChannelItem(title: channelTitle, imageURLString: channelImageURLPath, items: episodeItems)
        return channelItem
    }
}
