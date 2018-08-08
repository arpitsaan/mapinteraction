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
    private var viewModel = MainViewModel()
    
    //view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addHotelDetailsView()
    }
    
    func setupMap() {
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        mapView.addAnnotations(viewModel.annotations)
        
        //add tap gesture on map
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapMapView))
        mapView.addGestureRecognizer(tapGesture)
        
        //select first annotation
        selectAnnotationAtIndex(0)
    }
    
    func addHotelDetailsView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let hotelDetailsVC = storyboard.instantiateViewController(withIdentifier: "HotelDetailsViewController") as? HotelDetailsViewController {
            
            self.hotelDetailsVC = hotelDetailsVC
            hotelDetailsVC.delegate = self
            
            self.view.addSubview(hotelDetailsVC.view)
            
            //pass data
            hotelDetailsVC.hotels = self.viewModel.hotels
        }
    }
}

//------------------
// Map Interaction
//------------------
extension MainViewController: MKMapViewDelegate {
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
        let selectedAnnotation = view.annotation as? HotelAnnotation
        
        guard let index = selectedAnnotation?.index else {
            return
        }
        
        guard let coordinate = selectedAnnotation?.coordinate else {
            return
        }
        
        moveMap(coordinate: coordinate)
        hotelDetailsVC?.showHotelAtIndex(index: index, animated: true)
    }
    
    func selectAnnotationAtIndex(_ index: Int) {
        guard index < self.viewModel.annotations.count else {
            return
        }
        
        let annotation = self.viewModel.annotations[index]
        mapView.selectAnnotation(annotation, animated: true)
        moveMap(coordinate: annotation.coordinate)
    }
    
    func moveMap(coordinate: CLLocationCoordinate2D) {
        //zoom to 1 km radius
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        self.mapView?.setRegion(region, animated: true)
    }
}

//------------------------------
// Hotel Details View Delegate
//------------------------------
extension MainViewController: HotelDetailsViewDelegate {
    func listViewItemDidScrollTo(indexPath: IndexPath) {
        selectAnnotationAtIndex(indexPath.item)
    }
}


