//
//  RSSFeed.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-11.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
        /// Converts RSSFeed item to and array of episodes
        ///
        /// - Returns: [Episode]
        func toEpisodes() -> [Episode] {
        
        var episodes = [Episode]()
        
        // IF the podcast doesn't have a url for the episodes image, we set
        // the episode image to the Podcast cover image insted.
        let feedImageUrl = self.iTunes?.iTunesImage?.attributes?.href
        self.items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            if episode.episodeImageUrl == nil {
                episode.episodeImageUrl = feedImageUrl  // Use podcast coverimage url insted
            }
            episodes.append(episode)
        })
        return episodes
  }

}
