//
//  TrainLineViewModel.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/12/24.
//

import Foundation

class TrainLineViewModel: ObservableObject {
    @Published var stations: [Station] = []

    // Fetch stations for the selected train line
    func fetchStations(for line: String) {
        guard let url = Bundle.main.url(forResource: "mta_stations", withExtension: "json") else {
            print("Error: mta_stations.json not found.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedStations = try JSONDecoder().decode([Station].self, from: data)

            // Filter stations that include the selected train line
            let filteredStations = decodedStations.filter { $0.train_line.contains(line) }

            if line == "E" {
                // Reorder stations for the E train
                let eTrainOrder = [
                    "Jamaica Center–Parsons/Archer",
                    "Sutphin Blvd-Archer Av-JFK Airport",
                    "Jamaica-Van Wyck",
                    "Briarwood",
                    "Kew Gardens–Union Tpke",
                    "75th Avenue",
                    "Forest Hills-71st Avenue",
                    "Jackson Hts-Roosevelt Av",
                    "Queens Plaza",
                    "Court Sq-23 St",
                    "Lexington Av/53 St",
                    "5 Av/53 St",
                    "7 Av",
                    "50th Street",
                    "42 St/Port Authority Bus Terminal",
                    "34 St-Penn Station",
                    "23rd Street",
                    "14th Street",
                    "W 4 St-Washington Sq",
                    "Spring Street",
                    "Canal Street",
                    "Park Place / Chambers Street / WTC / Cortland Street"
                ]

                self.stations = filteredStations.sorted { station1, station2 in
                    guard let index1 = eTrainOrder.firstIndex(of: station1.name),
                          let index2 = eTrainOrder.firstIndex(of: station2.name) else {
                        return false
                    }
                    return index1 < index2
                }
            } else {
                // Default behavior for other train lines
                self.stations = filteredStations
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
