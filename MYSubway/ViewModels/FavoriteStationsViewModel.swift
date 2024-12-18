//
//  FavoriteStationsViewModel.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/24/24.
//


import SwiftUI

class FavoriteStationsViewModel: ObservableObject {
    @AppStorage("favoriteStationIDs") private var favoriteStationIDsStorage: String = "" // Store as a comma-separated string
    @Published var favoriteStations: [Station] = [] // Favorited stations
    private var allStations: [Station] = [] // All stations from JSON

    init() {
        loadAllStations()
        loadFavorites()
    }

    // Convert storage string to array
    private var favoriteStationIDs: [Int] {
        get {
            favoriteStationIDsStorage
                .split(separator: ",")
                .compactMap { Int($0) }
        }
        set {
            favoriteStationIDsStorage = newValue
                .map { String($0) }
                .joined(separator: ",")
        }
    }

    private func loadAllStations() {
        guard let url = Bundle.main.url(forResource: "mta_stations", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            allStations = try JSONDecoder().decode([Station].self, from: data)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }

    func loadFavorites() {
        favoriteStations = allStations.filter { favoriteStationIDs.contains($0.id) }
    }

    func toggleFavorite(_ station: Station) {
        if favoriteStationIDs.contains(station.id) {
            favoriteStationIDs.removeAll { $0 == station.id } // Remove the station ID
        } else {
            favoriteStationIDs.append(station.id) // Add the station ID
        }
        loadFavorites() // Update the `favoriteStations` list
    }

    func isFavorite(_ station: Station) -> Bool {
        favoriteStationIDs.contains(station.id)
    }

    func removeFavorite(_ station: Station) {
        favoriteStationIDs.removeAll { $0 == station.id }
        loadFavorites()
    }

    func removeFavorites(at offsets: IndexSet) {
        for index in offsets {
            let station = favoriteStations[index]
            removeFavorite(station)
        }
    }
}
