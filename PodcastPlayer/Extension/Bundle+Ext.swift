//
//  Bundle+Ext.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/25.
//

import Foundation

extension Bundle {
    
    static func ValueForString(key: String) -> String? {
        
        return Bundle.main.infoDictionary?[key] as? String
    }
}
