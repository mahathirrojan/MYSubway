//
//  Station.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/10/24.
//

import Foundation

// MARK: - Station Model
struct Station: Codable, Identifiable {
    let id: Int // Use Int because that's the type in your JSON
    let name: String
    let train_line: [String] // JSON has this field, not `routes`
    let borough: String
    let location: String? // Optional because not all entries have "location"

    var routes: [String] {
        return train_line // Aliasing `train_line` as `routes` for compatibility
    }
}
