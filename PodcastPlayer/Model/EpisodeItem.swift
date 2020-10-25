//
//  EpisodeItem.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

struct ChannelItem {
    let title: String
    let imageUrlString: String
    let items: [EpisodeItem]
}

struct EpisodeItem {
    let title: String
    let pubDate: Date
    let link: String
    let description: String
    let imageUrlString: String
    let index: Int
}
