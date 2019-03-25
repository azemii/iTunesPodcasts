//
//  PodcastSearchController.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-18.
//  Copyright © 2019 Armend. All rights reserved.
//
// 1. Register cell
// 2. Define how many rows
// 3. Dequeue and reuse cell.

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellID = "cellId"
    var podcasts = [
        Podcast(trackName: "Let's build that app", artistName: "Ching tong long", trackCount: 10, artworkUrl100: nil ),
        Podcast(trackName: "Dream", artistName: "Steve Jobs", trackCount: 10, artworkUrl100: nil)
    ]
    
    
    // Implementing a SearchController
    let searchController = UISearchController(searchResultsController: nil) // nil = get results on THIS view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
    }
    

    
    // MARK: - Search method.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(with: searchText) { (podcastsArray) in
            self.podcasts = podcastsArray
            self.tableView.reloadData()
        }
        
//         Does the same thing only shorter.
//        APIService.shared.fetchPodcasts(with: searchText) {
//            self.podcasts = $0
//            self.tableView.reloadData()
//        }
        
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
//        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")" // Avoid getting "optional" in text.
//        cell.textLabel?.numberOfLines = -1
//        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
    
    
    //MARK: - Setup methods.
    fileprivate func setupTableView() { // confined usage to PodcastsSearchController.swift
        // Register cell for tableView.
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
}
