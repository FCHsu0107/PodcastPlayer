//
//  UIView+SnapKit.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation
import UIKit.UIView
import SnapKit

// Ref. https://github.com/SnapKit/SnapKit/issues/448

extension UIView {

    var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
}
