//
//  HomeView.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0 // Track the current tab

    var body: some View {
        VStack {
            Spacer()

            // TabView with custom animation
            TabView(selection: $selectedTab) {
                FavoriteStationsView()
                    .tag(0)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }

                TrainLinesView()
                    .tag(1)
                    .tabItem {
                        Label("Train Lines", systemImage: "list.dash")
                    }

                SubwayAlertsView()
                    .tag(2)
                    .tabItem {
                        Label("Subway Alerts", systemImage: "exclamationmark.triangle.fill")
                    }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab) // Smooth animation on tab change
            .padding(.top, -40) // Adjusts the positioning of TabView to align better with the title
        }
    }
}

#Preview {
    HomeView()
}
