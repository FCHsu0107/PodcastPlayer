//
//  UIImage+Ext.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import UIKit

enum ImageAsset: String {

    //playback
    case play
    case pause
    
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}
