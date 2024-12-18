// SubwayAlertsView.swift
// created by Mahathir Rojan

import SwiftUI

struct AlertError: Identifiable {
    let id = UUID()
    let message: String
}

struct SubwayAlertsView: View {
    @StateObject private var viewModel = AlertsViewModel()
    @State private var selectedTrain: String? = nil // Track the selected train for filtering
    @State private var showChatbot = false // State to track chatbot view presentation

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Train Filter Picker
                    trainFilterPicker()

                    if viewModel.alerts.isEmpty {
                        Text("No active alerts at this time.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List {
                            ForEach(filteredAlerts()) { alertEntity in
                                VStack(alignment: .leading, spacing: 5) {
                                    if let headerText = alertEntity.alert.headerText?.translation.first?.text {
                                        Text(headerText)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }

                                    if let descriptionText = alertEntity.alert.mercuryAlert?.alertType {
                                        Text(descriptionText)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    if let activePeriod = alertEntity.alert.activePeriod?.first,
                                       let endTimestamp = activePeriod.end {
                                        Text("Active until: \(formattedDate(from: endTimestamp))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    // Train route icons
                                    if let informedEntities = alertEntity.alert.informedEntity {
                                        HStack(spacing: 8) { // Add spacing between icons
                                            ForEach(informedEntities.compactMap { sanitizeRouteId($0.routeId) }, id: \.self) { routeId in
                                                Image(getIconName(for: routeId))
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .clipShape(Circle()) // Optional: Circular icons
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.fetchAlerts() // Fetch alerts on pull-to-refresh
                        }
                    }
                }

                // Circular Button for Chatbot
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showChatbot.toggle()
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .padding()
                        }
                        .sheet(isPresented: $showChatbot) {
                            GeminiChatbotView() // Navigate to the chatbot view
                        }
                    }
                }
            }
            .navigationTitle("Subway Alerts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchAlerts()
            }
            .alert(item: $viewModel.errorMessage) { errorWrapper in
                SwiftUI.Alert(
                    title: Text("Error"),
                    message: Text(errorWrapper.message),
                    dismissButton: SwiftUI.Alert.Button.default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Train Filter Picker
    @ViewBuilder
    private func trainFilterPicker() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) { // Add spacing between icons
                // "All" Option
                Button(action: {
                    selectedTrain = nil
                }) {
                    Text("All")
                        .padding(10)
                        .background(selectedTrain == nil ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(8)
                        .foregroundColor(.primary)
                }

                // Train options based on alerts
                ForEach(uniqueTrainsFromAlerts(), id: \.self) { train in
                    Button(action: {
                        selectedTrain = train
                    }) {
                        Image(getIconName(for: train))
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .background(selectedTrain == train ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Filtered Alerts
    private func filteredAlerts() -> [AlertEntity] {
        guard let selectedTrain = selectedTrain else { return viewModel.alerts }
        return viewModel.alerts.filter { alertEntity in
            guard let informedEntities = alertEntity.alert.informedEntity else { return false }
            return informedEntities.contains { sanitizeRouteId($0.routeId) == selectedTrain }
        }
    }

    // MARK: - Extract Unique Trains
    private func uniqueTrainsFromAlerts() -> [String] {
        var uniqueTrains = Set<String>()
        for alertEntity in viewModel.alerts {
            if let informedEntities = alertEntity.alert.informedEntity {
                for entity in informedEntities {
                    if let train = sanitizeRouteId(entity.routeId) {
                        uniqueTrains.insert(train)
                    }
                }
            }
        }
        return Array(uniqueTrains).sorted()
    }

    // MARK: - Get Icon Name
    private func getIconName(for routeId: String) -> String {
        switch routeId {
        case "6X":
            return "6D"
        case "FS":
            return "SF"
        case "FX":
            return "F"
        case "S":
            return "S"
        case "H":
            return "H"
        case "SIR":
            return "SI"
        default:
            return routeId
        }
    }

    // Helper function to format date
    private func formattedDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Helper function to sanitize route IDs
    private func sanitizeRouteId(_ routeId: String?) -> String? {
        guard let routeId = routeId else { return nil }
        return routeId.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
    }
}

#Preview {
    SubwayAlertsView()
}
