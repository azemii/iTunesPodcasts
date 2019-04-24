//
//  ImageDownloader.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-16.
//  Copyright © 2019 Armend. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class ImageDownloader: Operation {
//    
//    var imageUrl: String
//    var podcast: Podcast
//    init(url: String, podcast: Podcast) {
//        self.imageUrl = url
//    }
//    
//    override func main() {
//        if self.isCancelled {
//            return
//        }
//        guard let url = URL(string: imageUrl) else { return }
//        
//        let imageData = try! Data(contentsOf: url)
//        if self.isCancelled { return }
//        
//        if imageData.count > 0 {
//            image = UIImage(data: imageData)
//            
//        }
//        
//        
//        
//    }
//}
