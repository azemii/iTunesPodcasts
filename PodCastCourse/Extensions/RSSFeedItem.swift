//
//  RSSFeedItem.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-11.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeedItem {
    
    /// Replaces HTTP with HTTPS from the RSSFeedItem podcast image
    ///
    /// - Returns: A secure URL containing HTTPS insted of HTTP
    func createSecureURL() -> String? {
        guard let url = self.iTunes?.iTunesImage?.attributes?.href else {
            //            print("NOT GOING THRU")
            return nil
        }
        let secureUrl = url.convertToHTTPS()
        return secureUrl
    }
}
