//
//  PlayerDetailsView.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-13.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer


class PlayerDetailsView: UIView {
    //MARK: - Local Variables
    var panGesture: UIPanGestureRecognizer!
    var episode: Episode! {
        didSet {
            
            setupNowPlayingInfo()
            
            miniEpisodeTitleLabel.text = episode.title
            episodeTitleLabel.text = episode.title
            authorLabel.text = episode.author
            
            if let episodeImageUrl = episode.episodeImageUrl {
                guard let url = URL(string: episodeImageUrl) else { return }
                episodeImageView.sd_setImage(with: url)
//                 miniEpisodeImageView.sd_setImage(with: url)
                
                
                miniEpisodeImageView.sd_setImage(with: url) { (image, _, _, _) in
                    var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                    guard let image = image else { return }
                    
                    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                        return image
                    })
                    
                    nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                }
            }else { print("Empty url...") }
            
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
        
        setupAudioSession()
        setupRemoteControll()
        setupGestures()
        observePlayerCurrentTime()
        observeIfPlayerIsPlaying()
    }
    
    
    //MARK: - Methods
    @objc func handleTapMaximizer() {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarContoller
        mainTabBarController?.maximizePlayerDetails(with: nil)
        panGesture.isEnabled = false // disables ability to scroll when in maxview
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            print("Began")
        } else if sender.state == .changed {
            handlePanChange(with: sender)
        } else if sender.state == .ended {
            handlePanEnd(with: sender)
            }
    }
    
    /// Handle the animation effects when we are moving the miniplayerView
    /// - parameter with: The UIPanGestureRecognizer sender
    func handlePanChange(with sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.superview) // superview is maintabbar
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        
        let newAlpha = 1 + translation.y / 200
        self.miniPlayerView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = 0 - translation.y / 200
    }
    
    /// Handle the animation effects when we let go of the miniplayerView
    /// - parameter with: The UIPanGestureRecognizer sender
    func handlePanEnd(with sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.superview)
        let velocity = sender.velocity(in: self.superview)
        // When we let go, let the view go back to it's original origin.
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            // Remove all CGATransform effects on this layer.
            self?.transform = .identity
            // When the miniplayer alpha value reaches 0, that's the threshold for
            // our transition.
            if translation.y < -200 || velocity.y < -500 {
                self?.handleTapMaximizer()
                self?.panGesture.isEnabled = false // In maxView we don't want to drag the view.X-Men Dark Phoenix.
                
                // If the miniplayer still hasn't reached 0, we return it back to
                // full alpha and hide the maximized.
            } else {
                self?.miniPlayerView.alpha = 1
                self?.maximizedStackView.alpha = 0
            }
        })
    }
    
    /// Plays and pauses the audio and changes the icon to represent the status of the playback.
    @objc func handlePlayAndPause() {
        if player.timeControlStatus == .paused {
            enlargePodcastImageView()
            player.play()
//            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
//            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            changePlayButtonsImage(with: #imageLiteral(resourceName: "pause"))
        }else if player.timeControlStatus == .playing {
            shrinkPodcastImageView()
//            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
//            miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            changePlayButtonsImage(with: #imageLiteral(resourceName: "play"))
            player.pause()
        }
        
    }

    @IBAction func miniPlayerHandlePlayAndPause(_ sender: Any) {
        handlePlayAndPause()
        let test = #imageLiteral(resourceName: "play")
        print(self.playPauseButton.imageView?.image)
        print(test)
    }
    @IBAction func miniPlayerHandleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    /// Removes current UIView from the superview.
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarContoller
        mainTabBarController?.minimizePlayerDetails()
        panGesture.isEnabled = true
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
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximizer)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        panGesture.isEnabled = false // We only want it on for the miniplayerDetailsView.
    }
    
    /// Enables the audio to play in the background.
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .init())
            
        } catch let sessionErr{
            print("Failed to activate session", sessionErr)
            
        }
        
    }
    
    /// Changes the the Image of the playbutton on the MainView and on the Mini Details view on the .normal state.
    /// - parameter with: The Image that will be on the
    func changePlayButtonsImage(with image: UIImage) {
        self.playPauseButton.setImage(image, for: .normal)
        self.miniPlayerPlayPauseButton.setImage(image, for: .normal)
    }
    
    // MARK: Oberservers
    
    /// Checks how many seconds have elapsed since playback started and updates the current
    /// time label.
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {[weak self] (time) in
            
            self?.currentTimeLabel.text = time.toFormatedString()
            self?.setupLockScreenCurrentTime()
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    /// Checks if the player is currently playing audio and only then will call to enlarge podcast image.
    /// Also sets the total duration time label.
    fileprivate func observeIfPlayerIsPlaying() {
        let time = CMTime(value: 1, timescale: 3) // 1/3 second = 0.3 seconds
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargePodcastImageView() // Only when audio is heard will this be called.
            let totalDurationOfPodcast = self?.player.currentItem?.duration
            self?.totalDurationLabel.text = totalDurationOfPodcast?.toFormatedString()
        }
    }
    
    //MARK: Lock screen info
    
    fileprivate func setupRemoteControll() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {[weak self]  (_) -> MPRemoteCommandHandlerStatus in
            self?.player.play()
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self?.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self]  (_) -> MPRemoteCommandHandlerStatus in
            self?.player.pause()
            self?.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self?.miniPlayerPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            return .success
        }
        
        // When you use the button on the headphones, pauses or plays.changePlayButtonsImage(with: #imageLiteral(resourceName: "pause"))
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            
            self?.handlePlayAndPause()
            return .success
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String : Any ]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        // Lock screen property
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    fileprivate func setupLockScreenCurrentTime() {
        var nowPlaying = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        guard let currentItem = player.currentItem else { return }
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTime = player.currentTime()
        
        nowPlaying?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        nowPlaying?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlaying
        
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
//     func resetEpisodeView() {
//        currentTimeLabel.text = "00:00"
//        changePlayButtonsImage(with: #imageLiteral(resourceName: "pause"))
//        currentTimeSlider.value = 0
//        totalDurationLabel.text = "--:--"
//    }
    
    //MARK: Static
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
    }


    
    
    
}
















































