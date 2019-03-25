//
//  PodcastCell.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-24.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import UIKit


class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    var podcast: Podcast! {
        didSet {
            self.trackName.text = podcast.trackName
            self.artistName.text = podcast.artistName
            self.episodeCount.text = String(podcast.trackCount ?? -1)
            }
    }
    
}
