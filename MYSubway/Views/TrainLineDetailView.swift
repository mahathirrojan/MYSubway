//
//  TrainLineDetailView.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/12/24.
//

import SwiftUI

struct TrainLineDetailView: View {
    var line: String
    @StateObject private var viewModel = TrainLineViewModel()

    var body: some View {
        VStack {
            if viewModel.stations.isEmpty {
                Text("No stations found for \(line) train.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    // Group stations by borough
                    ForEach(groupStationsByBorough(), id: \.key) { borough, stations in
                        Section(header: BoroughHeaderView(borough: borough)) {
                            ForEach(stations, id: \.id) { station in
                                NavigationLink(destination: StationDetailView(station: station)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        // Station Name
                                        Text(station.name)
                                            .font(.headline)

                                        // Train Lines in a horizontally scrollable container
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(station.train_line, id: \.self) { train in
                                                    Image(train)
                                                        .resizable()
                                                        .frame(width: 32, height: 32)
                                                        .clipShape(Circle())
                                                        .overlay(
                                                            Circle().stroke(Color.gray, lineWidth: 1)
                                                        )
                                                        .padding(4)
                                                }
                                            }
                                        }
                                        .frame(height: 40) // Limit the height of the scrollable container
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("\(line) Train")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchStations(for: line)
        }
    }

    // Function to group stations by borough
    private func groupStationsByBorough() -> [(key: String, value: [Station])] {
        let grouped = Dictionary(grouping: viewModel.stations) { $0.borough }
        return grouped.sorted { $0.key < $1.key }
    }
}

// Custom Borough Header View
struct BoroughHeaderView: View {
    let borough: String

    var body: some View {
        ZStack {
            Color.blue.opacity(0.2) // Background color similar to Apple Music
                .cornerRadius(10) // Rounded corners
                .padding(.horizontal)

            Text(borough)
                .font(.title3)
                .bold()
                .foregroundColor(.blue) // Text color
                .padding()
        }
        .frame(height: 60) // Adjust height for consistency
    }
}

#Preview {
    TrainLineDetailView(line: "1")
}
