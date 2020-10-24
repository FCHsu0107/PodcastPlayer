//
//  UIImageView+Kingfisher.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import UIKit.UIImageView

import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
