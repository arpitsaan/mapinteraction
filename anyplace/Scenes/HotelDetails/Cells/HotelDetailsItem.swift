//
//  HotelDetailsItem.swift
//  anyplace
//
//  Created by Arpit Agarwal on 08/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit

class HotelDetailsItem: NSObject {
    
    var name: String?
    var imageURL: URL?
    var priceString: String?
    var address: String?
    var amenitiesString: String?
    var roomsString: String?
    
    init(with hotel: Hotel) {
        super.init()
        
        //name
        self.name = hotel.name
        
        //image
        self.imageURL = URL(string: hotel.coverPhoto.url)
        
        //rate
        if let rateText = hotel.rateText {
            self.priceString = rateText + " ~ / month";
        }
        
        //address
        self.address = hotel.address

        //amenities (v1)
        let amenities = [["Private Bath", hotel.amenities.privateBath ? "yes" : "no"].joined(separator: " : "),
                         ["Shared Kitchen", hotel.amenities.sharedKitchen ? "yes" : "no"].joined(separator: " : ")]
        self.amenitiesString = amenities.joined(separator: ", ")
        
        //rooms (v1)
        var roomsStringComponents = [String]()
        for room in hotel.rooms {
            guard let rate = room.rateText else {
                continue
            }
            let roomString = ["\(room.name)", "\(rate)"].joined(separator: "\n")
            roomsStringComponents.append(roomString)
        }
        
        self.roomsString = roomsStringComponents.joined(separator: "\n\n")
    }
}
