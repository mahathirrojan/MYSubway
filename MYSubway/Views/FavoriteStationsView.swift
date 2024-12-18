//
//  FavoriteStationsView.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/24/24.
//

import SwiftUI

struct FavoriteStationsView: View {
    @StateObject private var viewModel = FavoriteStationsViewModel()
    @State private var showStationsView = false // Controls slider visibility

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favoriteStations.isEmpty {
                    Text("No favorite stations added.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.favoriteStations, id: \.id) { station in
                            NavigationLink(destination: StationDetailView(station: station)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(station.name)
                                            .font(.headline)
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
                            }
                        }
                        .onDelete(perform: viewModel.removeFavorites) // Remove from favorites and AppStorage
                    }
                }

                Spacer()

                // Button to add new favorites
                Button(action: {
                    showStationsView = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
            .navigationTitle("Favorite Stations")
            .navigationBarTitleDisplayMode(.inline) // Center title at the top
            .sheet(isPresented: $showStationsView) {
                AddFavoriteStationsView(viewModel: viewModel, stationsViewModel: StationsViewModel())
            }
        }
    }
}

#Preview {
    FavoriteStationsView()
}
