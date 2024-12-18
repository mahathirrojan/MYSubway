//
//  StationTrainTimesViewModel.swift
//  MYSubway
//
//  Created by Mahathir Rojan
//

import Foundation

class StationTrainTimesViewModel: ObservableObject {
    static let shared = StationTrainTimesViewModel() // Singleton instance

    @Published var trainTimes: [String: [String: [TrainTime]]] = [:] // Station ID (as String) -> Line -> Train Times

    private var timer: Timer? // Timer for the countdown

    private init() {
        generateInitialTrainTimes()
        startCountdown() // Start the countdown when the app launches
    }

    func getTrainTimes(for station: Station) -> [String: [TrainTime]] {
        let stationID = String(station.id) // Convert ID to String
        print("Fetching train times for station ID: \(stationID)")
        print("Train Times Available: \(trainTimes[stationID] ?? [:])")
        return trainTimes[stationID] ?? [:]
    }

    private func generateInitialTrainTimes() {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)
        let currentTotalMinutes = currentHour * 60 + currentMinute

        // Frequency map based on the time of day
        let frequencyMap: [(start: Int, end: Int, frequency: ClosedRange<Int>)] = [
            (0 * 60, 5 * 60, 20...20), // 12am - 5am: every 20 minutes
            (5 * 60, 6 * 60, 10...10), // 5am - 6am: every 10 minutes
            (6 * 60, 12 * 60, 3...5),  // 6am - 12pm: every 3-5 minutes
            (12 * 60, 15 * 60, 4...8), // 12pm - 3pm: every 4-8 minutes
            (15 * 60, 21 * 60, 2...7), // 3pm - 9pm: every 2-7 minutes
            (21 * 60, 24 * 60, 8...10) // 9pm - 12am: every 8-10 minutes
        ]

        let currentFrequency = frequencyMap.first {
            currentTotalMinutes >= $0.start && currentTotalMinutes < $0.end
        }?.frequency ?? 20...20

        print("Generating initial train times with frequency range: \(currentFrequency)")

        // Generate train times for all stations
        for station in loadAllStations() {
            let stationID = String(station.id) // Convert ID to String
            print("Generating train times for: \(station.name) (ID: \(stationID)) with lines: \(station.train_line)")
            var stationTrainTimes: [String: [TrainTime]] = [:]
            for line in station.train_line {
                var uptownTimes: [TrainTime] = []
                var downtownTimes: [TrainTime] = []
                var nextTime = 0

                // Generate uptown train times
                while nextTime < 120 {
                    let frequency = Int.random(in: currentFrequency)
                    nextTime += frequency
                    uptownTimes.append(TrainTime(direction: "Uptown", line: line, minutes: nextTime))
                }

                nextTime = 0

                // Generate downtown train times
                while nextTime < 120 {
                    let frequency = Int.random(in: currentFrequency)
                    nextTime += frequency
                    downtownTimes.append(TrainTime(direction: "Downtown", line: line, minutes: nextTime))
                }

                stationTrainTimes[line] = (uptownTimes + downtownTimes).sorted { $0.minutes < $1.minutes }
            }
            trainTimes[stationID] = stationTrainTimes
        }

        print("Generated train times for all stations.")
    }

    private func loadAllStations() -> [Station] {
        guard let url = Bundle.main.url(forResource: "mta_stations", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let stations = try? JSONDecoder().decode([Station].self, from: data) else {
            print("Failed to load station data.")
            return []
        }
        print("Successfully loaded station data.")
        return stations
    }

    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateTrainTimes()
            }
        }
    }

    private func updateTrainTimes() {
        print("Updating train times...")
        for (stationID, stationTimes) in trainTimes {
            var updatedTimes: [String: [TrainTime]] = [:]
            for (line, times) in stationTimes {
                var newTimes = times.map { trainTime -> TrainTime in
                    var updatedTime = trainTime
                    updatedTime.minutes -= 1 // Decrement the time
                    return updatedTime
                }

                // Remove trains that have been "Now" for more than 1 minute
                newTimes.removeAll { $0.minutes < -1 }

                updatedTimes[line] = newTimes.sorted { $0.minutes < $1.minutes }
            }
            trainTimes[stationID] = updatedTimes
        }
        print("Train times updated.")
    }

    deinit {
        timer?.invalidate()
    }
}
