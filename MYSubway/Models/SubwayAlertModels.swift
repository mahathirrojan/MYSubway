//
//  SubwayAlertModels.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/11/24.
//

import Foundation

struct AlertFeed: Codable {
    let header: FeedHeader
    let entity: [AlertEntity]
}

struct FeedHeader: Codable {
    let gtfsRealtimeVersion: String
    let incrementality: String
    let timestamp: Int
    let mercuryFeedHeader: MercuryFeedHeader?

    enum CodingKeys: String, CodingKey {
        case gtfsRealtimeVersion = "gtfs_realtime_version"
        case incrementality
        case timestamp
        case mercuryFeedHeader = "transit_realtime.mercury_feed_header"
    }
}

struct MercuryFeedHeader: Codable {
    let mercuryVersion: String

    enum CodingKeys: String, CodingKey {
        case mercuryVersion = "mercury_version"
    }
}

struct AlertEntity: Codable, Identifiable {
    let id: String
    let alert: Alert
}

struct Alert: Codable {
    let activePeriod: [ActivePeriod]?
    let informedEntity: [InformedEntity]?
    let headerText: Translation?
    let mercuryAlert: MercuryAlert?

    enum CodingKeys: String, CodingKey {
        case activePeriod = "active_period"
        case informedEntity = "informed_entity"
        case headerText = "header_text"
        case mercuryAlert = "transit_realtime.mercury_alert"
    }
}

struct ActivePeriod: Codable {
    let start: Int?
    let end: Int?
}

struct InformedEntity: Codable {
    let agencyId: String?
    let routeId: String?
    let stopId: String?

    enum CodingKeys: String, CodingKey {
        case agencyId = "agency_id"
        case routeId = "route_id"
        case stopId = "stop_id"
    }
}

struct MercuryAlert: Codable {
    let createdAt: Int?
    let updatedAt: Int?
    let alertType: String?
    let displayBeforeActive: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alertType = "alert_type"
        case displayBeforeActive = "display_before_active"
    }
}

struct Translation: Codable {
    let translation: [TranslationText]
}

struct TranslationText: Codable {
    let text: String
    let language: String
}
