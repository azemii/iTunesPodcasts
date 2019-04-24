//
//  String.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-11.
//  Copyright © 2019 Armend. All rights reserved.
//

import Foundation

extension String {
    /// Replaces HTTP in a string to HTTPS
    func convertToHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
