//
//  StationsView.swift
//  MYSubway
//

import SwiftUI

struct StationsView: View {
    @ObservedObject var viewModel: StationsViewModel // Passed from the parent view
    @State private var searchText: String = "" // Search text entered by the user
    @State private var selectedTrainLine: String? = nil // Selected train line for filtering

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for a station...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { newValue in
                        viewModel.filterStations(searchText: newValue, trainLine: selectedTrainLine)
                    }

                // Train Line Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Button(action: {
                            selectedTrainLine = nil
                            viewModel.filterStations(searchText: searchText, trainLine: nil)
                        }) {
                            Text("All")
                                .padding()
                                .background(selectedTrainLine == nil ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }

                        ForEach(viewModel.uniqueTrainLines, id: \.self) { line in
                            Button(action: {
                                selectedTrainLine = line
                                viewModel.filterStations(searchText: searchText, trainLine: line)
                            }) {
                                Image(line) // Dynamically show train icons
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                    .background(selectedTrainLine == line ? Color.blue.opacity(0.8) : Color.gray.opacity(0.3))
                                    .cornerRadius(16)
                                    .padding(2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Stations List
                List(viewModel.filteredStations, id: \.id) { station in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(station.name)
                                .font(.headline)

                            // Display train icons
                            HStack {
                                ForEach(station.train_line, id: \.self) { route in
                                    Image(route)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .clipShape(Circle())
                                        .padding(2)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Stations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StationsView(viewModel: StationsViewModel())
}
