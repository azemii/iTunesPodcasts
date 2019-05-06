//
//  PlayerDetailsView.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-13.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    var episode: Episode! {
        didSet {
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let episodeImageUrl = episode.episodeImageUrl {
                guard let url = URL(string: episodeImageUrl) else { return }
                episodeImageView.sd_setImage(with: url)
            }else{ print("Empty url...") }
            
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false // faster playback time.
        return avPlayer
    }()

    fileprivate func playEpisode() {
        guard let streamUrl = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: streamUrl)
        player.replaceCurrentItem(with: playerItem) 
        player.play()
//        print("trying to play at url:", episode.streamUrl)
    }
    
    
    //MARK: - IBOutlets
    
    // The superview is the UIWindows objc defined in the
    // EpisodesController.swift file.
    
    @IBOutlet weak var episodeTitleLabel: UILabel!{
        didSet {
            self.episodeTitleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true // will not allow subviews to extend futher than the bounds of parentview.
            episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    

    // Will enlagre the image only when the audio has started!
    // After "time" has elapsed since playback, we will execute the block of code.
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = CMTime(value: 1, timescale: 3) // 1/3 second = 0.3 seconds
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            self.enlargePodcastImageView()
        }
    }
    
    //MARK: - Methods
    @objc func handlePlayAndPause() {
        if player.timeControlStatus == .paused {
            enlargePodcastImageView()
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else if player.timeControlStatus == .playing {
            shrinkPodcastImageView()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
        }
        
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    //MARK: Animations
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func animateImageViewTransform(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = transform
        })
    }
    fileprivate func enlargePodcastImageView() {
         //This effectively clears our view of any pre-defined transform, resetting any changes that have been applied by modifying its transform property.
        animateImageViewTransform(.identity)
    }
    
    fileprivate func shrinkPodcastImageView() {
        animateImageViewTransform(shrunkenTransform)
}

}
















































