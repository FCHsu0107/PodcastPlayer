//
//  Date+Ext.swift
//  PodcastPlayer
//
//  Created by Fu-Chiung HSU on 2020/10/24.
//

import Foundation

extension Date {
    func getDateString(formet: String = "yyyy/MM/dd") -> String {
        let formmatter = DateFormatter()
        formmatter.dateFormat = formet
        return formmatter.string(from: self)
    }
}
