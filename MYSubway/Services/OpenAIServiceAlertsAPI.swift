//
//  OpenAIServiceAlertsAPI.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/18/24.
//

import Foundation

class OpenAIServiceAlertsAPI {
    static let shared = OpenAIServiceAlertsAPI()
    private let openAIEndpoint = "https://api.openai.com/v1/chat/completions"
    private let mtaEndpoint = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/camsys%2Fsubway-alerts.json"

    private var openAIAPIKey: String = "" // API Key loaded from Secrets.plist
    private var alertsContext: String = ""
    private var isLoaded: Bool = false // Tracks if alerts are fully loaded

    private init() {
        loadAPIKey()
        fetchServiceAlerts { _ in }
    }

    // MARK: - Load API Key from Secrets.plist
    private func loadAPIKey() {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["OpenAIAPIKey"] as? String else {
            fatalError("❌ OpenAI API Key is missing in Secrets.plist!")
        }
        self.openAIAPIKey = key
    }

    // MARK: - Fetch Service Alerts
    func fetchServiceAlerts(completion: @escaping (Result<[AlertEntity], Error>) -> Void) {
        guard let url = URL(string: mtaEndpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid MTA URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
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
                let alerts = alertFeed.entity
                self.alertsContext = self.formatAlertsForOpenAI(alerts: alerts)
                self.isLoaded = true
                completion(.success(alerts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Send Query to OpenAI
    func sendUserQuery(query: String, completion: @escaping (String) -> Void) {
        guard isLoaded else {
            completion("The bot is still loading service alerts. Please try again in a moment.")
            return
        }

        let payload: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "The following are real-time MTA service alerts:\n\(alertsContext)"],
                ["role": "user", "content": query]
            ],
            "max_tokens": 300
        ]

        guard let url = URL(string: openAIEndpoint),
              let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            completion("Failed to process your query. Please try again.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let choices = jsonResponse["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                completion("Failed to parse response from OpenAI API.")
                return
            }

            completion(content)
        }.resume()
    }

    // MARK: - Format Alerts for OpenAI
    private func formatAlertsForOpenAI(alerts: [AlertEntity]) -> String {
        return alerts.map { alert in
            var details = ""

            // Add Alert Header
            if let header = alert.alert.headerText?.translation.first?.text {
                details += "Alert: \(header)\n"
            }

            // Add Active Period
            if let activePeriod = alert.alert.activePeriod?.first, let start = activePeriod.start {
                let formattedStartDate = Date(timeIntervalSince1970: TimeInterval(start))
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                details += "Active from: \(formatter.string(from: formattedStartDate))\n"
            }

            // Add Affected Trains
            if let informedEntities = alert.alert.informedEntity?.compactMap({ $0.routeId }) {
                details += "Trains affected: \(informedEntities.joined(separator: ", "))\n"
            }

            return details
        }.joined(separator: "\n\n")
    }
}
