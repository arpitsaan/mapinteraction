//
//  ListViewController.swift
//  TestMap
//
//  Created by Arpit Agarwal on 8/4/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import Kingfisher

protocol ListViewDelegate: class {
    func listViewOnHide()
    func listViewItemDidScrollTo(indexPath: IndexPath)
}

class ListViewController: UIViewController {

    var hotels: Hotels?
    weak var delegate: ListViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
    }
    
    @IBAction func hide(_ sender: Any) {
        delegate?.listViewOnHide()
    }
    
    func refreshWithHotels(hotels : Hotels?) {
        guard let hotelsUnwrapped = hotels else {
            return
        }
        
        self.hotels = hotelsUnwrapped
        self.collectionView.reloadData()
    }
    
    
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let hotels = self.hotels else {
            return 0
        }
        
        return hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        cell.nameLabel.text = "\(indexPath.item)"
        
        guard let hotels = self.hotels else {
            return cell
        }
        
        let hotel = hotels[indexPath.item]
        cell.nameLabel.text = hotel.name
        
        let url = URL(string: hotel.coverPhoto.url)
        cell.imageView.kf.setImage(with: url)
        
        let price = hotel.rate as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        
        if let rate = formatter.string(from: price) {
            cell.rateLabel.text = rate + " ~ / month";
        }
        
        cell.addressLabel.text = hotel.address

        var amenities = "Private Bath : " + hotel.amenities.privateBath.description
        amenities += ", Shared Kitchen : " + hotel.amenities.sharedKitchen.description
        
        cell.amenitiesLabel.text = amenities
        
        var roomsString = ""
        for room in hotel.rooms {
            let roomRate = hotel.rate as NSNumber
            
            if let rate = formatter.string(from: roomRate) {
                let currentRoomString = room.name + "\n" + rate + "\n\n"
                roomsString.append(currentRoomString)
            }
            
        }
        
        cell.roomsLabel.text = roomsString
        
        return cell
    }
    
    func getAmenitiesString(hotel: Hotel) {
        var amenitiesString = ""
        amenitiesString += hotel.amenities.barLounge.description
    }
    
    func showHotelAtIndex(index: Int) {
        collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        delegate?.listViewItemDidScrollTo(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}
