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
            
            
            let url = URL(string: episode.episodeImageUrl?.convertToHTTPS() ?? "")
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
