//
//  String.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-11.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation

extension String {

    /// Replaces HTTP with HTTPS from any string and returns it with the replaced version.
    ///
    /// - Returns: A secure URL containing HTTPS insted of HTTP
    func convertToHTTPS() -> String {
        if self.contains("https"){
            return self
        }else if self.contains("http") {
            let replacedString = self.replacingOccurrences(of: "http", with: "https")
            return replacedString
        } else {
            return self
        }
        
    }
}
