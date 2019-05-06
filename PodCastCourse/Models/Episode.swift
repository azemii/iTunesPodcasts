//
//  Episode.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-04.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import FeedKit


struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    var episodeImageUrl: String?
    let author: String
    let streamUrl: String
    
    
    
    // Assign episode with the RSSItem recived from parsing
    // the "rssFeedUrl" using "FeedKit"
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? "-1"
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? "-1"
        self.episodeImageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href?.convertToHTTPS() ?? nil
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.streamUrl = feedItem.enclosure?.attributes?.url?.convertToHTTPS() ?? "" // link for the audiofile.
    }
    
}
