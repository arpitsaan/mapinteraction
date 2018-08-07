//
//  ViewController.swift
//  anyplace
//
//  Created by Arpit Agarwal on 02/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    fileprivate var listViewController: ListViewController?
    @IBOutlet weak var mapView: MKMapView!
    
    var hotels: Hotels?
    var annotations = [HotelAnnotation]()
    var selectedAnnotation : HotelAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        mapView.showsCompass = false
        mapView.showsUserLocation = true
    }
    
    @objc func panUsed(sender: UIPanGestureRecognizer) {
        guard let listViewController = self.listViewController else {
            return
        }
        
        let translation = sender.translation(in: listViewController.view)
        
        let velocity = sender.velocity(in: listViewController.view)

        if sender.state == .ended {
            let listViewY = listViewController.view.frame.origin.y;
            var lvFrame = listViewController.view.frame;
            let velocityThresh: CGFloat = 500
            let showHeight: CGFloat = lvFrame.size.height - 150
            let heightThresh: CGFloat = lvFrame.size.height/2
            
            if (velocity.y < -velocityThresh) {
                //swiped top
                lvFrame.origin.y = 0;
            }else if (velocity.y > velocityThresh) {
                //swiped down
                lvFrame.origin.y = lvFrame.size.height - 150;
            }else {
                if(listViewY < heightThresh) {
                    //top snap
                    lvFrame.origin.y = 0;
                }
                else if(listViewY >= heightThresh) {
                    //bottom snap
                    lvFrame.origin.y = showHeight;
                }
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                listViewController.view.frame = lvFrame
            }, completion: nil)
            
            //            listViewController.view.center = CGPoint(x: listViewController.view.center.x, y: listViewController.view.center.y + translation.y)
        }else {
            listViewController.view.center = CGPoint(x: listViewController.view.center.x, y: listViewController.view.center.y + translation.y)
            
            sender.setTranslation(CGPoint.zero, in: listViewController.view)
        }
        
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
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panUsed))
            //            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            //            swipeGestureRecognizer.direction = .up
            listViewController.view.addGestureRecognizer(panGestureRecognizer)
            listViewController.view.frame.origin.y = self.view.frame.size.height - 150
            
            
            listViewController.refreshWithHotels(hotels: self.hotels)
            self.selectAnnotationAtIndex(index: 0)
            
            self.view.addSubview(listViewController.view)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController: MKMapViewDelegate {
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
        listViewController?.showHotelAtIndex(index: index)
    }
    
    func selectAnnotationAtIndex(index: Int) {
        self.mapView.selectAnnotation(self.annotations[index], animated: false)
        
        let coordinate = annotations[index].coordinate
        let annotation = annotations[index]
        
        mapView.selectAnnotation(annotation, animated: false)
        moveMap(coordinate: coordinate, mapView: mapView)
    }
    
    func moveMap(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}

extension MainViewController: ListViewDelegate {
    func listViewOnHide() {
        self.listViewController?.view.removeFromSuperview()
        self.listViewController = nil
    }
    
    func listViewItemDidScrollTo(indexPath: IndexPath) {
        selectAnnotationAtIndex(index: indexPath.item)
    }
    
}


