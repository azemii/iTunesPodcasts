//
//  APIService.swift
//  PodCastCourse
//
//  Created by Armend on 2019-03-22.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation
import Alamofire


enum EnumParameters {
    case media(media: String)
}


// All networking code here.
class APIService {
    
    let baseItunesSearchURL = "https://itunes.apple.com/search"
    
    
    ///Singelton
    static let shared = APIService()
    
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
            // Decoding search results data.
            do {
                
                // JSON
//                let jsonResponse = try JSONSerialization.jsonObject(with:
//                data, options: []) as! [String: Any]
//                print(jsonResponse)
                
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResults.results)
            } catch let decodeError {
                print("Failed to decode: \(decodeError)")
            }
            
        }
        
    }
    
    
    // Decoder will only get the key/value matching the variable name inside of this stuct.
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
