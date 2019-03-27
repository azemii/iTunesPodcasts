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
    
    // MARK: Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.purple
        label.numberOfLines = 0
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
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
    
  
    
    
    //MARK: - Setup methods.
    fileprivate func setupTableView() { // confined usage to PodcastsSearchController.swift
        // Register cell for tableView.
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        // We register the cell using nib insted of the standard way, custom cell class.
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView() // Removes all horizontal lines in table
    }
    
    
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
}
