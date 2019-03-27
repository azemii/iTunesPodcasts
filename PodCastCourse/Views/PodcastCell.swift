//
//  PodcastCell.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-24.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    // Labels in stackview.
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    
    var podcast: Podcast! {
        didSet {
            self.trackName.text = podcast.trackName
            self.artistName.text = podcast.artistName
            self.episodeCount.text = "\(podcast.trackCount ?? -1 ) Episodes"
            
         
            guard var imageUrl = URL(string: podcast.artworkUrl600 ?? "") else {
                return
            }
            // All this code is replace with 1 life using SDWeb.
//            URLSession.shared.dataTask(with: imageUrl) { (data, respoonse, error) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        /*
//                         Dont set the image to self.imageView.
//                         That imageview is a default imageview provided to the tableViewCell
//                         and it's not the custom imageView we have set up.
//
//                        Adding an image to that imageView will place it ontop of our custom ImageView.
//                        */
//                        self.podcastImageView.image = UIImage(data: data)
//                        print("Finished downloading image with: \(data) bytes...")
//                    }
//                }
//            }.resume()
            
            podcastImageView.sd_setImage(with: imageUrl, completed: nil)
            
        }
    }
    
}
