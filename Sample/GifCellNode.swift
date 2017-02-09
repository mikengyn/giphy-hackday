//
//  GifCellNode.swift
//  Sample
//
//  Created by Michael Nguyen on 2017-02-08.
//  Copyright © 2017 AsyncDisplayKit. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class GifCellNode: ASCellNode {
    let imageNode = ASNetworkImageNode()
    
    var gif: JMGiphy?
    
    required init(with giphy : JMGiphy) {
        super.init()
        self.gif = giphy
        imageNode.url = URL(string: giphy.previewUrl)   // init our image by passing in the url
        self.addSubnode(self.imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageSize = imageNode.image?.size
        print("imageNode= \(imageNode.bounds), image=\(imageSize)")
        
        var imageRatio: CGFloat = 0.5   // default
        if let currentGif = self.gif {
            imageRatio = CGFloat(currentGif.height/currentGif.width)
        }
        
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        let stackLayout = ASStackLayoutSpec.horizontal()
        stackLayout.justifyContent = .start
        stackLayout.alignItems = .start
        stackLayout.style.flexShrink = 1.0
        stackLayout.children = [imagePlace]
        
        return  ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: stackLayout)
    }
    
    
}
