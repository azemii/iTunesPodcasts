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
        print("Looking for episodes at feedUrl: ", podcast?.feedUrl ?? "NO_URL -1")
        
        guard let feedUrl = podcast?.feedUrl else { return }
        // If http, replace it with https
        let secureFeedUrl = feedUrl.contains("http") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        let parser = FeedParser(URL: url)
        fetchEpisodes(with: parser)
        
    }
    
    //MARK: - Setup Work
    fileprivate func setupTableview() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId) // default cell atm.
        tableView.tableFooterView = UIView() // remove extra lines below cells.
    }
    
    //MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = episode.title + "\n" + episode.pubDate.description
        return cell
    }
    
    //MARK: - Helper methods
    fileprivate func fetchEpisodes(with parser: FeedParser){
        parser.parseAsync { (result) in
            print("succesfully parsed feed: ", result.isSuccess)
            switch result{
            case let .rss(feed):
                var episodes = [Episode]()
                // Adding items from RSS feed to our episodes array.
                feed.items?.forEach({ (feedItem) in
                    let episode = Episode(feedItem: feedItem)
                    episodes.append(episode)
                    self.episodes = episodes
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case let .failure(error):
                print("Failed to retrive a feed: ", error)
            default:
                print("Found a feed... Not rss")
            }
        }
    }
}
