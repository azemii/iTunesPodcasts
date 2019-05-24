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
    var podcasts = [Podcast]()
    
    
    // Implementing a SearchController
    // Specify nil if you want to display the search results in the same view controller that displays your searchable content.
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.rowHeight = 132
        
        searchBar(searchController.searchBar, textDidChange: "voong")
        setupTableView()
        setupSearchBar()
    }
    

    
    // MARK: - Search bar methods.
    // MARK: Searching and requesting
    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        // Search after 0.5 seconds, less agressive search method.
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            APIService.shared.fetchPodcasts(with: searchText) { (podcastsArray) in
                self.podcasts = podcastsArray
                self.tableView.reloadData()
            }
            
            //         Does the same thing only shorter.
            //        APIService.shared.fetchPodcasts(with: searchText) {
            //            self.podcasts = $0
            //            self.tableView.reloadData()
            //        }
        })

    }
    
    // MARK: Cancel button implementation
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.podcasts = []
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - TableView Methods
    // MARK: Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a search term."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.purple
        label.numberOfLines = 0
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // No header when we have podscats, 250 high when empty.
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeController = EpisodesController()
        episodeController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodeController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
  
    
    
    //MARK: - Setup methods.
    /// Registering xib as resuable cell and setting definesPresentationContext = true
    fileprivate func setupTableView() { // confined usage to PodcastsSearchController.swift
        // Register cell for tableView.
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        // Register the podcast.xib as the resuable cell.
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
        // To be able to see a pushing view ontop of PodcastSearchController we have to
        // set true. Otherwise our pushing view will not be covering this view, hence not showing.
        self.definesPresentationContext = true
        
        
    }
    
    
    /// Customizing the searchController and assigning self to delegate searchController.
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
    func donwloadingJSON(with searchTerm: String) {
        
        guard let searchURL = URL(string: "https://itunes.apple.com/search?media=podcast&term=\(searchTerm)") else {return}
        let data = try! Data(contentsOf: searchURL)
        
        let json = try! JSONSerialization.jsonObject(with: data)
        print(json)
  
        
    }
}
