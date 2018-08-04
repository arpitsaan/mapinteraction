//
//  HotelAnnotation.swift
//  anyplace
//
//  Created by Arpit agarwal on 04/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import MapKit

class HotelAnnotation: NSObject, MKAnnotation {
    let title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.address = address
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}
