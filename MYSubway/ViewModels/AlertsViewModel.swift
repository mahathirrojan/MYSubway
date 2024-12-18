//
//  AlertsViewModel.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/11/24.
//

import Foundation
import Combine

class AlertsViewModel: ObservableObject {
    @Published var alerts: [AlertEntity] = []
    @Published var errorMessage: AlertError?


    private var dataFetcher = SubwayDataFetcher()

    func fetchAlerts() {
        dataFetcher.fetchSubwayAlerts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let alerts):
                    self?.alerts = alerts
                case .failure(let error):
                    // Update to set `errorMessage` as an `AlertError`
                    self?.errorMessage = AlertError(message: error.localizedDescription)
                }
            }
        }
    }
}
