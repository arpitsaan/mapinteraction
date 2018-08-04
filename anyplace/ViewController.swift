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
    @IBOutlet weak var hotelsCollectionView: UICollectionView!
    var hotels: Hotels?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotelsCollectionView.register(UINib.init(nibName: "HotelDetailsCell", bundle: nil), forCellWithReuseIdentifier: "HotelDetailsCell")
        
        if let flowLayout = hotelsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1);
        }
        
        getData()
        addMapPins()
        
    }
    
    func getData() {
        
        if let path = Bundle.main.path(forResource: "anyplace-hotels", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) as Data
                hotels = try JSONDecoder().decode(Hotels.self, from: jsonData)
                print(hotels)
            } catch {
                // handle error
            }
        }
    }
    
    func addMapPins() {
        guard let hotels = self.hotels else {
            return
        }
        
        var annotations = [HotelAnnotation]()
        for hotel in hotels {
            guard let lat = hotel.lat, let lon = hotel.lon else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
            let hotelAnnotation = HotelAnnotation(title: hotel.name, address: hotel.address, coordinate: coordinate)
            annotations.append(hotelAnnotation)
        }

        mapView.addAnnotations(annotations)

        //FIXME - lot of optional and ! random :/ ^^^
        
        //fixme - map centering
        if let coordinate = annotations.last?.coordinate {
            mapView.setCenter(coordinate, animated: false)
        }
    }
    
    
    
}

extension ViewController: MKMapViewDelegate {
    
}

