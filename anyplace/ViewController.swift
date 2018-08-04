//
//  ViewController.swift
//  anyplace
//
//  Created by Arpit Agarwal on 02/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var hotels: Hotels?
    var annotations = [HotelAnnotation]()
    var selectedAnnotation : HotelAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        addMapPins()
        
    }
    
    func getData() {
        
        if let path = Bundle.main.path(forResource: "anyplace-hotels", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) as Data
                hotels = try JSONDecoder().decode(Hotels.self, from: jsonData)
            } catch {
                // handle error
            }
        }
    }
    
    func addMapPins() {
        guard let hotels = self.hotels else {
            return
        }
        
        var count = 0
        for hotel in hotels {
            guard let lat = Double(hotel.latitude), let lon = Double(hotel.longitude) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            let hotelAnnotation = HotelAnnotation(title: hotel.name, address: hotel.address, coordinate: coordinate, index: count)
            count = count+1
            
            annotations.append(hotelAnnotation)
        }

        mapView.addAnnotations(annotations)

        //FIXME - lot of optional and ! random :/ ^^^
        
        //fixme - map centering
        if let coordinate = annotations.first?.coordinate {
            mapView.setCenter(coordinate, animated: false)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? HotelAnnotation
    }
}

