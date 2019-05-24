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
            
            miniEpisodeTitleLabel.text = episode.title
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let episodeImageUrl = episode.episodeImageUrl {
                guard let url = URL(string: episodeImageUrl) else { return }
                episodeImageView.sd_setImage(with: url)
                 miniEpisodeImageView.sd_setImage(with: url)
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
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniEpisodeTitleLabel: UILabel!
    @IBOutlet weak var miniPlayerPlayPauseButton: UIButton!
    
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
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    
    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximizer)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        observePlayerCurrentTime()
        observePlayerIsPlaying()
    }
    
    
    //MARK: - Methods
    @objc func handleTapMaximizer() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarContoller
        mainTabBarController?.maximizePlayerDetails(with: nil)
        
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            print("Began")
        } else if sender.state == .changed {
            let translation = sender.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
            self.miniPlayerView.alpha = 1 + translation.y / 300
            self.maximizedStackView.alpha = 0 - translation.y / 300
            
            
            print("Changed")
        } else if sender.state == .ended {
            if miniPlayerView.alpha < 0.5 {
                handleTapMaximizer()
                self.transform = .identity
            } else {
            // When we let go, let the view go back to it's original origin.
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                // Remove all CGATransform effects on this layer.
                self.transform = .identity
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
                })
            }
          
        }
    }
    
    /// Plays and pauses the audio and changes the icon to represent the status of the playback.
    @objc func handlePlayAndPause() {
        if player.timeControlStatus == .paused {
            enlargePodcastImageView()
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else if player.timeControlStatus == .playing {
            shrinkPodcastImageView()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
        }
        
    }

    @IBAction func miniPlayerHandlePlayAndPause(_ sender: Any) {
        handlePlayAndPause()
    }
    @IBAction func miniPlayerHandleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    /// Removes current UIView from the superview.
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarContoller
        mainTabBarController?.minimizePlayerDetails()
    }
    /// Handles timechanges using the slider.
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentageOfTotalDuration = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        // If user uses slider before the item has been initilized this will be nan and crash the app
        if !durationInSeconds.isNaN{
            let seekTimeInSeconds = Float(durationInSeconds) * percentageOfTotalDuration
            let seekTime = CMTimeMake(value: Int64(seekTimeInSeconds), timescale: 1)
            seekAndPlayWith(delta: seekTime)
            
        } else { return }
    }
    
    @IBAction func handleRewind15(_ sender: Any) {
        seekToCurrentTime(delta: -15)
        
    }
    @IBAction func handleFastForward15(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        player.volume = sender.value
        
    }
    
    /// Fast forward or rewinds with the input delta.
    fileprivate func seekToCurrentTime(delta: Int64) {
        let deltaSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), deltaSeconds)
        seekAndPlayWith(delta: seekTime)
    }
    
    /// Updates the slider to correspond to the amout of time elapsed.
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / duration
        currentTimeSlider.value = Float(percentage)
        
    }
    
    // MARK: Oberservers
    
    /// Checks how many seconds have elapsed since playback started and updates the current
    /// time label.
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] (time) in
            self?.currentTimeLabel.text = time.toFormatedString()
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    /// Checks is the player is currently playing audio and only then will call to enlarge podcast image.
    /// Also sets the total duration time label.
    fileprivate func observePlayerIsPlaying() {
        let time = CMTime(value: 1, timescale: 3) // 1/3 second = 0.3 seconds
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargePodcastImageView() // Only when audio is heard will this be called.
            let totalDurationOfPodcast = self?.player.currentItem?.duration
            self?.totalDurationLabel.text = totalDurationOfPodcast?.toFormatedString()
        }
    }
    
 
    
    //MARK: Animations
    /// Defines the shrunken-down scale of the podcast image.
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    /// Handels the animation of the podcast image.
    fileprivate func animateImageViewTransform(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = transform
        })
    }
    
    /// Enlarges the podcast image back to 1.0 scale
    fileprivate func enlargePodcastImageView() {
         //This effectively clears our view of any pre-defined transform, resetting any changes that have been applied by modifying its transform property.
        animateImageViewTransform(.identity)
    }
    
    /// Shrinks the podscast image down to the value of shrunkenTransform constant.
    fileprivate func shrinkPodcastImageView() {
        animateImageViewTransform(shrunkenTransform)
}
    
    /// Seeks to to time using delta. If the player is paused
    /// when we request time change, it will stay paused.
    fileprivate func seekAndPlayWith(delta: CMTime) {
        player.seek(to: delta) {[weak self] _ in
            if self?.player.timeControlStatus == .playing { // if player is paused, dont play after timechange.
                self?.player.play()
            }
        }
    }
    fileprivate func resetEpisodeView() {
        currentTimeLabel.text = "00:00"
        playPauseButton.imageView?.image = #imageLiteral(resourceName: "pause")
        currentTimeSlider.value = 0
        totalDurationLabel.text = "--:--"
    }
    
    //MARK: Static
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
    }


    
    
    
}
















































