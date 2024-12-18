// AddFavoriteStationsView

//
//  AddFavoriteStationsView
//

import SwiftUI

struct AddFavoriteStationsView: View {
    @ObservedObject var viewModel: FavoriteStationsViewModel
    @ObservedObject var stationsViewModel: StationsViewModel // Shared instance
    @Environment(\.presentationMode) private var presentationMode // To dismiss view

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search for a station...", text: $stationsViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Stations List
                List(stationsViewModel.filteredStations, id: \.id) { station in
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

                        // Checkmark for selected favorites
                        if viewModel.isFavorite(station) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle()) // Makes the entire row tappable
                    .onTapGesture {
                        viewModel.toggleFavorite(station) // Toggle favorite
                    }
                }
            }
            .navigationTitle("Add Favorites")
            .onAppear {
                stationsViewModel.filterStations(searchText: stationsViewModel.searchText, trainLine: nil)
                viewModel.loadFavorites() // Reload favorites to ensure changes are reflected
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss() // Dismiss view
                    }
                }
            }
        }
    }
}
