//
//  PlayerDetailsView.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-13.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit
import Foundation

class PlayerDetailsView: UIView {
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            
            if let episodeImageUrl = episode.episodeImageUrl {
            guard let url = URL(string: episodeImageUrl) else { return }
                episodeImageView.sd_setImage(with: url)
                
            } else { print("Empty url...") }
        }
    }
        
    
    // The superview is the UIWindows objc defined in the
    // EpisodesController.swift file. 
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var episodeTitleLabel: UILabel!{
        didSet {
            self.episodeTitleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!
}



