//
//  Podcast.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-18.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation

// Itunes API does not always return these values, set to optinal.
struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var trackCount: Int?
    var artworkUrl100: String?
    
}

