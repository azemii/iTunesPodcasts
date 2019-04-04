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
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? "-1"
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? "-1"
    }
}
