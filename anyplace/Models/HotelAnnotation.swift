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
    
    init(title: String, address: String) {
        self.title = title
        self.address = address
        
        self.coordinate = CLLocationCoordinate2D.init(latitude: 28.410992, longitude: 77.191932)//Fixme - to double acc
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}
