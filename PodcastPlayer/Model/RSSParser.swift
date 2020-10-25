//
//  RSSParser.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

import FeedKit

enum ParserError: Error {
    case urlNotFound
    case rssFeedNotFound
    case parserDataFail
    case reponseError
    case unexpectedError(Error?)
}

// TODO: need to refactor
class RSSParser {
    func request(
        urlPath: String,
        completion: @escaping (Result<RSSFeed, Error>) -> Void
    ) {
        guard let url = URL(string: urlPath) else { return completion(.failure(ParserError.urlNotFound)) }
        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    return completion(.failure(error))
                case .success(let feed):
                    switch feed {
                    case .rss(let rss):
                        return completion(.success(rss))
                    default:
                        return completion(.failure(ParserError.reponseError))
                    }
                }
            }
        }
    }
    
    func parserRssFeed(_ feed: RSSFeed) -> ChannelItem? {
        guard let channelTitle = feed.title, // 科技島讀
              let channelImageURLPath = feed.image?.url, // String
              let items = feed.items
        else {
            return nil
        }
    
        var episodeItems: [EpisodeItem] = []
        
        for item in items {
            guard let title = item.title,
                  let link = item.link,
                  let description = item.description,
                  let pubDate = item.pubDate,
                  let imageURLPath = item.iTunes?.iTunesImage?.attributes?.href
            else {
                continue
            }
            let episodeItem = EpisodeItem(title: title, pubDate: pubDate, link: link, description: description, imageUrlString: imageURLPath, index: episodeItems.count)
            episodeItems.append(episodeItem)
        }
        
        let channelItem = ChannelItem(title: channelTitle, imageUrlString: channelImageURLPath, items: episodeItems)
        return channelItem
    }
}
