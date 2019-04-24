//
//  EpisodeCellTableViewCell.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-04.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet{
            self.titleLabel.text = episode.title
            self.descriptionLabel.text = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            self.pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            
            // Best to convert the string here. If we get a episode URL we will convert
            // and if we dont have a episode url, we will conver the podcast conver image
            // url.
            let url = URL(string: episode.episodeImageUrl?.convertToHTTPS() ?? "")
            SDImageCache.shared().config.maxCacheAge = 3600 * 24 * 7 //1 Week
            SDImageCache.shared().maxMemoryCost = 1024 * 1024 * 20 //Aprox 20 images
            SDImageCache.shared().config.shouldCacheImagesInMemory = false //Default True => Store images in RAM cache for Fast performance
            SDImageCache.shared().config.shouldDecompressImages = false
            SDWebImageDownloader.shared().shouldDecompressImages = false
            SDImageCache.shared().config.diskCacheReadingOptions = NSData.ReadingOptions.mappedIfSafe
                episodeImageView.sd_setImage(with: url)
            
        }
    }

    @IBOutlet weak var labelsStackView: UIStackView! {
        didSet {
            labelsStackView.spacing = 4
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet{
            descriptionLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!

    
}
