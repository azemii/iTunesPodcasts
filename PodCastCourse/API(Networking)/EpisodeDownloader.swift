//
//  ImageDownloader.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-04.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import FeedKit

class EpisodeDownloader {
    
    /// Download episodes from a podcast and assign them to data the episodesController datasource.
    ///
    ///- parameter parser: FeedKit parser used to download and read rrs feed.
    ///- parameter episodesController: Designated viewController, where the downloaded
    /// rrs feed will be converted and stored in data source array.
     static func fetchEpisodes(with parser: FeedParser, and episodesController: EpisodesController ){
        // Parser using URL assigned from call site.
        parser.parseAsync { (result) in
            print("succesfully parsed feed: ", result.isSuccess)
            switch result{
            case .rss(let feed):
             episodesController.episodes = feed.toEpisodes()
                DispatchQueue.main.async {
                    episodesController.tableView.reloadData()
                }
            case let .failure(error):
                print("Failed to retrive a feed: ", error)
            default:
                print("Found a feed... Not rss")
            }
        }
    }
}


