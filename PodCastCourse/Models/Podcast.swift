//
//  Podcast.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-18.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation

// Some items may be nil from the iTunes API JSON.
struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var trackCount: Int?
    var artworkUrl600: String?
    var feedUrl: String?
    
    
}

