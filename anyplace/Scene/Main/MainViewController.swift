//
//  MainViewController.swift
//  anyplace
//
//  Created by Arpit Agarwal on 02/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    //properties
    fileprivate var hotelDetailsVC: HotelDetailsViewController?
    @IBOutlet weak var mapView: MKMapView!

    var hotels: Hotels?
    var annotations = [HotelAnnotation]()
    var selectedAnnotation : HotelAnnotation?
    
    //view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    //data
    func getData() {
        let dataManager = APDataManager.init(localJsonNamed: "anyplace-hotels")
        dataManager.delegate = self
        dataManager.loadData()
    }
    
    //core view setup
    func showHotelDetailsView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let hotelDetailsVC = storyboard.instantiateViewController(withIdentifier: "HotelDetailsViewController") as? HotelDetailsViewController {
            
            self.hotelDetailsVC = hotelDetailsVC
            hotelDetailsVC.delegate = self
            
            self.view.addSubview(hotelDetailsVC.view)
            
            //pass data
            hotelDetailsVC.hotels = self.hotels
        }
    }
    
    func refreshViews() {
        addMapPins()
        showHotelDetailsView()
        selectAnnotationAtIndex(index: 0)
    }
}


//------------------
//  Data Manager
//------------------
extension MainViewController: APDataManagerDelegate {
    
    func dataManagerLoadSuccessful(hotels: Hotels) {
        self.hotels = hotels
        refreshViews()
    }
    
    func dataManagerLoadFailed() {
        //FIXME: Show app error state
        let alert = UIAlertController.init(title: "Data Load Failed!", message: "Something went wrong while loading app data.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: nil))
        self.show(alert, sender: nil)
    }
}


//------------------
// Map
//------------------
extension MainViewController: MKMapViewDelegate {
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
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        
        //add tap gesture on map
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapMapView(sender: UITapGestureRecognizer) {
        guard let mapView = self.mapView else {
            return
        }
        
        if mapView.selectedAnnotations.count > 0 {
            for annotation in mapView.selectedAnnotations {
                mapView.deselectAnnotation(annotation, animated: true)
            }
            hotelDetailsVC?.hideView(animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? HotelAnnotation
        
        guard let index = self.selectedAnnotation?.index else {
            return
        }
        
        guard let coordinate = self.selectedAnnotation?.coordinate else {
            return
        }
        
        guard let mapView = self.mapView else {
            return
        }
        
        moveMap(coordinate: coordinate, mapView: mapView)
        hotelDetailsVC?.showHotelAtIndex(index: index, animated: true)
    }
    
    func selectAnnotationAtIndex(index: Int) {
        self.mapView.selectAnnotation(self.annotations[index], animated: false)
        
        let coordinate = annotations[index].coordinate
        let annotation = annotations[index]
        
        mapView.selectAnnotation(annotation, animated: false)
        moveMap(coordinate: coordinate, mapView: mapView)
    }
    
    func moveMap(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        //zoom to 1 km radius
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}

//------------------------------
// Hotel Details View Delegate
//------------------------------
extension MainViewController: HotelDetailsViewDelegate {
    func listViewItemDidScrollTo(indexPath: IndexPath) {
        selectAnnotationAtIndex(index: indexPath.item)
    }
}


