import Foundation
import Combine

class StationsViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var filteredStations: [Station] = []
    @Published var searchText: String = "" {
        didSet {
            filterStations(searchText: searchText, trainLine: selectedTrainLine)
        }
    }

    private var allStations: [Station] = []
    private var selectedTrainLine: String? = nil // Keep track of selected train line for filtering

    init() {
        loadStationsFromJSON()
    }

    var uniqueTrainLines: [String] {
        // Extract unique train lines
        let trainLines = allStations.flatMap { $0.train_line }
        return Array(Set(trainLines)).sorted()
    }

    func filterStations(searchText: String, trainLine: String?) {
        filteredStations = allStations.filter { station in
            let matchesSearch = station.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty
            let matchesTrainLine = trainLine == nil || station.train_line.contains(trainLine!)
            return matchesSearch && matchesTrainLine
        }
    }

    func selectTrainLine(_ trainLine: String?) {
        selectedTrainLine = trainLine
        filterStations(searchText: searchText, trainLine: trainLine)
    }

    private func loadStationsFromJSON() {
        guard let url = Bundle.main.url(forResource: "mta_stations", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedStations = try JSONDecoder().decode([Station].self, from: data)
            DispatchQueue.main.async {
                self.allStations = decodedStations
                self.filteredStations = decodedStations
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}

extension StationsViewModel {
    func getGTrainStations() -> [Station] {
        allStations.filter { $0.train_line.contains("G") }
    }
}
