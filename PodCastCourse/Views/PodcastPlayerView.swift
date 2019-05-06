//
//  PodcastPlayerView.swift
//  PodCastCourse
//
//  Created by Armend on 2019-04-25.
//  Copyright © 2019 Armend. All rights reserved.
//

import UIKit

class PodcastPlayerView: UIView {
    var mainVerticalStackView: UIStackView?
    var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("dismiss", for: .normal)
        button.sizeToFit()
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        button.titleLabel?.tintColor = .white
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func didMoveToSuperview() {
        print("moved to superView")
        fixConstraints()
        self.addSubview(dismissButton)
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.frame = frame
//    }
//    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    @objc func handleDismiss() {
        self.removeFromSuperview()
    }
    
}






extension PodcastPlayerView {
    
    func fixConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview!.topAnchor),
            self.rightAnchor.constraint(equalTo: superview!.rightAnchor),
            self.leftAnchor.constraint(equalTo: superview!.leftAnchor),
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor)
            ])
        
        
    }
    
}








