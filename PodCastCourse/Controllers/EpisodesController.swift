//
//  EpisodesController.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-28.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    var episodes = [Episode]()
    fileprivate let cellId = "CellId"
    
    // Set the title.
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodesAndUpdateTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()

    }
    
    // MARK: - Fetch
    fileprivate func fetchEpisodesAndUpdateTableView(){
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(with: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Work
    fileprivate func setupTableview() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView() // remove extra lines below cells.
    }
    
    //MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEpisode = episodes[indexPath.row]
        print("Episode Name: ", selectedEpisode.title)
        
        let window = UIApplication.shared.keyWindow
        
        // Returns all the elements declared inside of the xib file, but we only want
        // the UIView so we spcifify .first, to return the first element wich is the uiview.
        let playerView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self)?.first as! PlayerDetailsView
        playerView.frame = self.view.frame
        playerView.episode = selectedEpisode
        window?.addSubview(playerView)
    }
}
