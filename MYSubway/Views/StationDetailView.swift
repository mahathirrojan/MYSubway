import SwiftUI

struct StationDetailView: View {
    let station: Station
    @ObservedObject private var trainTimesViewModel = StationTrainTimesViewModel.shared // Singleton

    var body: some View {
        VStack(alignment: .leading) {
            Text(station.name)
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("Borough: \(station.borough)")
                .font(.headline)
                .foregroundColor(.gray)

            ScrollView {
                ForEach(trainGroups.keys.sorted(), id: \.self) { groupName in
                    let groupTrains = trainGroups[groupName]?.filter { station.train_line.contains($0) } ?? []

                    if !groupTrains.isEmpty {
                        GroupedTrainTimesView(
                            groupName: groupName,
                            groupTrains: groupTrains,
                            trainTimes: trainTimesViewModel.getTrainTimes(for: station)
                        )
                    }
                }
            }
        }
        .padding()
        .navigationTitle(station.name)
    }

    private let trainGroups: [String: [String]] = [
        "Blue Line": ["A", "C", "E"],
        "Orange Line": ["B", "D", "F", "M"],
        "Red Line": ["1", "2", "3"],
        "Green Line": ["4", "5", "6"],
        "Purple Line": ["7"],
        "Lime line": ["G"],
        "Yellow Line": ["N", "Q", "R", "W"],
        "Gray Line": ["L"],
        "Brown Line": ["J", "Z"],
        "Shuttle": ["S", "SF", "SR"]
    ]
}

struct GroupedTrainTimesView: View {
    let groupName: String
    let groupTrains: [String]
    let trainTimes: [String: [TrainTime]]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let uptownTimes = groupTrainTimes(for: "Uptown") {
                Text("Uptown")
                    .font(.headline)
                TrainTimesCardView(trainTimes: uptownTimes)
            }

            if let downtownTimes = groupTrainTimes(for: "Downtown") {
                Text("Downtown")
                    .font(.headline)
                TrainTimesCardView(trainTimes: downtownTimes)
            }
        }
        .padding(.vertical)
    }

    private func groupTrainTimes(for direction: String) -> [TrainTime]? {
        // Flatten and filter train times by direction, then sort them chronologically
        let groupedTimes = groupTrains
            .flatMap { trainTimes[$0]?.filter { $0.direction == direction } ?? [] }
            .sorted { $0.minutes < $1.minutes }

        return groupedTimes.isEmpty ? nil : groupedTimes
    }
}

struct TrainTimesCardView: View {
    let trainTimes: [TrainTime]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(trainTimes) { time in
                    VStack {
                        Image(time.line)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())

                        Text(
                            time.minutes == 0
                                ? "Now"
                                : (time.minutes < 0
                                    ? "Departed"
                                    : "\(time.minutes) min")
                        )
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct TrainTime: Identifiable {
    let id = UUID()
    let direction: String
    let line: String
    var minutes: Int
}
