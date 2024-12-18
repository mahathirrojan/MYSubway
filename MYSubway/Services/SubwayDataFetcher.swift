//
//  SubwayDataFetcher.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/11/24.
//

import Foundation

class SubwayDataFetcher {
    func fetchSubwayAlerts(completion: @escaping (Result<[AlertEntity], Error>) -> Void) {
        let urlString = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/camsys%2Fsubway-alerts.json"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let alertFeed = try JSONDecoder().decode(AlertFeed.self, from: data)
                completion(.success(alertFeed.entity))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
