//
//  CMTime.swift
//  PodCastCourse
//
//  Created by Armend on 2019-05-06.
//  Copyright © 2019 Armend. All rights reserved.
//

import AVKit

extension CMTime {
    
    /// Returns formated string in MM:SS format from CMTtime object.
    func toFormatedString() -> String {
//        let totalSeconds = 4210 //1h 10m 10s
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        var minutes = totalSeconds / 60
        if minutes > 60 {
            let hours = totalSeconds / 60 / 60
            minutes %= 60
            let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            return timeFormatString
        }else {
            let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
            return timeFormatString
        }
        
        
        
    }
}
