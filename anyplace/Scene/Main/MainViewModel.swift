//
//  MainViewModel.swift
//  anyplace
//
//  Created by Arpit Agarwal on 08/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import MapKit

class MainViewModel: NSObject {
    
    var hotels: Hotels?
    var annotations = [HotelAnnotation]()
    
    override init() {
        super.init()
        initData()
        initAnnotations()
    }
    
}

private extension MainViewModel {
    
    private func initData() {
        let dataManager = APDataManager.init(localJsonNamed: "anyplace-hotels")
        self.hotels = dataManager.hotels
    }
    
    private func initAnnotations() {
        guard let hotels = self.hotels else {
            return
        }
        
        for index in 0...hotels.count - 1 {
            let hotel = hotels[index]
            
            guard let lat = Double(hotel.latitude), let lon = Double(hotel.longitude) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            let hotelAnnotation = HotelAnnotation(title: hotel.name, address: hotel.address, coordinate: coordinate, index: index)
            annotations.append(hotelAnnotation)
        }
    }
    
}
