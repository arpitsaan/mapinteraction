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

    fileprivate var listViewController: ListViewController?
    @IBOutlet weak var mapView: MKMapView!
    
    var hotels: Hotels?
    var annotations = [HotelAnnotation]()
    var selectedAnnotation : HotelAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.mapView.addGestureRecognizer(tapGestureRecognizer)
        
        getData()
        addMapPins()
        showListView()
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
    }

    @objc func tap(sender: UITapGestureRecognizer) {
        //        if let _ = self.listViewController {
        //            //            listViewController.view.removeFromSuperview()
        //            //            self.listViewController = nil
        //        }
        //        else {
        //            showListView()
        //        }
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        guard let listViewController = self.listViewController else {
            return
        }
        
        if sender.direction == .up {
            if listViewController.view.frame.origin.y == self.view.frame.size.height - 150 {
                listViewController.view.frame.origin.y = self.view.frame.size.height / 2
            }
            else if listViewController.view.frame.origin.y == self.view.frame.size.height / 2 {
                listViewController.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func showListView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController {
            self.listViewController = listViewController
            listViewController.delegate = self
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            swipeGestureRecognizer.direction = .up
            listViewController.view.addGestureRecognizer(swipeGestureRecognizer)
            listViewController.view.frame.origin.y = self.view.frame.size.height - 150
            
            
            listViewController.refreshWithHotels(hotels: self.hotels)
            
            self.view.addSubview(listViewController.view)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? HotelAnnotation
        
        guard let index = self.selectedAnnotation?.index else {
            return
        }
                
        listViewController?.showHotelAtIndex(index: index)
    }
    
    func selectAnnotationAtIndex(index: Int, shouldAdjustMap: Bool) {
        //FIXME - map centering
        self.mapView.selectAnnotation(self.annotations[index], animated: false)
        
        let coordinate = annotations[index].coordinate
        let annotation = annotations[index]
        
        mapView.selectAnnotation(annotation, animated: false)
        
        if (shouldAdjustMap) {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(coordinate, span)
            
            mapView.setRegion(region, animated: true)
        }
    }
}

extension ViewController: ListViewDelegate {
    func listViewOnHide() {
        self.listViewController?.view.removeFromSuperview()
        self.listViewController = nil
    }
    
    func listViewItemDidScrollTo(indexPath: IndexPath) {
        selectAnnotationAtIndex(index: indexPath.item, shouldAdjustMap: true)
    }
    
}


