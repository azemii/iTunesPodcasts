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
    let searchController = UISearchController(searchResultsController: nil) // nil = get results on THIS view.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 132
        
        setupTableView()
        setupSearchBar()
    }
    

    
    // MARK: - Search bar methods.
    // MARK: Searching and requesting
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
           
        }
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
    
  
    
    
    //MARK: - Setup methods.
    fileprivate func setupTableView() { // confined usage to PodcastsSearchController.swift
        // Register cell for tableView.
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        // We register the cell using nib insted of the standard way, custom cell class.
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView() // Removes all horizontal lines in table
        
        // To be able to see a pushing view ontop of PodcastSearchController we have to
        // set true. Otherwise our pushing view will not be covering this view, hence not showing.
        self.definesPresentationContext = true
        
        
    }
    
    
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}
