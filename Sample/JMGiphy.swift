//
//  JMGiphy.swift
//  Sample
//
//  Created by Michael Nguyen on 2017-02-08.
//  Copyright © 2017 AsyncDisplayKit. All rights reserved.
//

import Foundation

class JMGiphy: NSObject {
    
    var name: String = ""
    var url: String = ""        
    var previewUrl: String = "" // preview
    var width: Double = 0
    var height: Double = 0
    
    init(name: String, url: String, previewUrl: String, width: Double, height: Double) {
        self.name = name
        self.url = url
        self.previewUrl = previewUrl
        self.width = width
        self.height = height
    }
    
}
