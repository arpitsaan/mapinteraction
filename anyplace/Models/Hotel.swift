//
//  Hotel.swift
//  anyplace
//
//  Created by Arpit Agarwal on 04/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import Foundation

typealias Hotels = [Hotel]

struct Hotel: Codable {
    let id: Int
    let name: String
    let neighborhood: Country
    let address: String
    let city: City
    let state, country: Country
    let latitude, longitude: String
    let coverPhoto: CoverPhoto
    let rate, deposit, minimumStay: Int
    let rating: Double
    let rooms: [Room]
    let amenities: HotelAmenities
    let houseRules: HouseRules
    let guides: [Guide]
    let isActive: Bool
    let listedAt: ListedAt
    let slug, tourDescription: String
    let photos: [CoverPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, neighborhood, address, city, state, country, latitude, longitude
        case coverPhoto = "cover_photo"
        case rate, deposit
        case minimumStay = "minimum_stay"
        case rating, rooms, amenities
        case houseRules = "house_rules"
        case guides
        case isActive = "is_active"
        case listedAt = "listed_at"
        case slug
        case tourDescription = "tour_description"
        case photos
    }
}

extension Hotel {
    
    //Initialize a formatter for currency
    //(since formatters are expensive)
    public static let rateFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale?
        return formatter
    }()

    //Read-Only formatted Hotel rate
    var rateText : String? {
        get {
            let hotelRate = rate as NSNumber
            return Hotel.rateFormatter.string(from: hotelRate)
        }
    }
}

extension Room {
    
    //Read-Only formatted Room rate
    var rateText : String? {
        get {
            let roomRate = rate as NSNumber
            return Hotel.rateFormatter.string(from: roomRate)
        }
    }
}

struct HotelAmenities: Codable {
    let wifi, weeklyHousekeeping, sharedKitchen, laundryOnSite: Bool
    let publicParking, fitnessCenter, privateBath, barLounge: Bool
    let complimentaryBreakfast: Bool
    
    enum CodingKeys: String, CodingKey {
        case wifi
        case weeklyHousekeeping = "weekly_housekeeping"
        case sharedKitchen = "shared_kitchen"
        case laundryOnSite = "laundry_on_site"
        case publicParking = "public_parking"
        case fitnessCenter = "fitness_center"
        case privateBath = "private_bath"
        case barLounge = "bar_lounge"
        case complimentaryBreakfast = "complimentary_breakfast"
    }
}

struct City: Codable {
    let id: Int
    let name: Name
    let code: Code
    let stateID: Int
    let image: CoverPhoto
    let slug: Slug
    let latitude, longitude: String
    let isActive: Bool
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, code
        case stateID = "state_id"
        case image, slug, latitude, longitude
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum Code: String, Codable {
    case la = "LA"
    case sf = "SF"
}

struct CoverPhoto: Codable {
    let url: String
}

enum Name: String, Codable {
    case losAngeles = "Los Angeles"
    case sanFrancisco = "San Francisco"
}

enum Slug: String, Codable {
    case losAngeles = "los-angeles"
    case sanFrancisco = "san-francisco"
}

struct Country: Codable {
    let id: Int
    let name, code: String
    let isoCode: ISOCode?
    let isActive: Bool
    let createdAt, updatedAt: String
    let cityID, countryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code
        case isoCode = "iso_code"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cityID = "city_id"
        case countryID = "country_id"
    }
}

enum ISOCode: String, Codable {
    case us = "US"
}

struct Guide: Codable {
    let id, hotelID: Int
    let info, createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case hotelID = "hotel_id"
        case info
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct HouseRules: Codable {
    let smokeAllowed, pedAllowed, partyAllowed, childrenSuitable: Bool
    let infantsSuitable: Bool
    let addtionalRules: String
    
    enum CodingKeys: String, CodingKey {
        case smokeAllowed = "smoke_allowed"
        case pedAllowed = "ped_allowed"
        case partyAllowed = "party_allowed"
        case childrenSuitable = "children_suitable"
        case infantsSuitable = "infants_suitable"
        case addtionalRules = "addtional_rules"
    }
}

enum ListedAt: String, Codable {
    case the11Days = "11 days"
    case the16Days = "16 days"
    case the3Months = "3 months"
    case the5Months = "5 months"
}

struct Room: Codable {
    let id: Int
    let name: String
    let rate, deposit, allotmentNumber, occupancyLimit: Int
    let beds: Int
    let bedSize: BedSize
    let privateBath: Bool
    let amenities: RoomAmenities
    
    enum CodingKeys: String, CodingKey {
        case id, name, rate, deposit
        case allotmentNumber = "allotment_number"
        case occupancyLimit = "occupancy_limit"
        case beds
        case bedSize = "bed_size"
        case privateBath = "private_bath"
        case amenities
    }
}

struct RoomAmenities: Codable {
    let tv, cableTv, desk, sink: Bool
    let refrigerator, microwave, petAllowed, smokeAllowed: Bool
    
    enum CodingKeys: String, CodingKey {
        case tv
        case cableTv = "cable_tv"
        case desk, sink, refrigerator, microwave
        case petAllowed = "pet_allowed"
        case smokeAllowed = "smoke_allowed"
    }
}

enum BedSize: String, Codable {
    case full = "Full"
    case king = "King"
    case queen = "Queen"
    case twin = "Twin"
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

