//
//  APIService.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-22.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

// Decoder will only get the key/value matching the variable name inside of this stuct.
struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}


// All networking code here.
class APIService {
    let baseItunesSearchURL = "https://itunes.apple.com/search"
    
    
    ///Singelton
    static let shared = APIService()
    private init(){}
    
    
    
    /// Searching for podcasts with a search term.
    ///
    /// - parameter searchText:        The search term used to search iTunes API.
    /// - parameter completionHandler: Retaining the podcast array that will be returned from the url request.
    ///
    func fetchPodcasts(with searchText: String, completionHandler: @escaping ([Podcast]) -> ()){
        let podcastParameters = ["term": searchText, "media": "podcast"] // Only searching for podcasts
        
        Alamofire.request(baseItunesSearchURL, method: .get, parameters: podcastParameters, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
            guard let data = dataResponse.data else {
                print("Failed to retrive data from urlRequest")
                return
            }
            // Decoding search results data with Decodeable.
            do {
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                print(searchResults)
                completionHandler(searchResults.results)
            } catch let decodeError {
                print("Failed to decode: \(decodeError)")
            }
            
        }
        
    }
    
    
    
    /// Fetching episodes for the spcified podcast.
    ///
    ///- parameter feedURL: Designated url to the RSSFeed.
    ///- parameter completionHandler:
    func fetchEpisodes(with feedUrl: String, completionHandler: @escaping ([Episode]) -> Void){
        let secureUrl = feedUrl.convertToHTTPS()
        guard let url = URL(string: secureUrl) else { return }
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            print("succesfully parsed feed: ", result.isSuccess)
            
            if let err = result.error {
                print("error retriving XML feed: ", err)
                return
            }
            guard let feed = result.rssFeed else { return }
            let episodes = feed.toEpisodes()
            completionHandler(episodes)
        }
    }
    
    

}
