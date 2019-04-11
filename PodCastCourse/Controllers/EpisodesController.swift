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
            fetchEpisodes()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()

    }
    
    // MARK: - Fetch
    fileprivate func fetchEpisodes(){
//        print("Looking for episodes at feedUrl: ", podcast?.feedUrl ?? "NO_URL -1")
        
        guard let feedUrl = podcast?.feedUrl else { return }
        // If http, replace it with https
        let secureFeedUrl = feedUrl.contains("https") ?  feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        let parser = FeedParser(URL: url)
        EpisodeDownloader.fetchEpisodes(with: parser, and: self)
        
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
}
