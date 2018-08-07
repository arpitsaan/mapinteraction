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

    var hotels: Hotels? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: ListViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
    }
    
    @IBAction func didTapApply(_ sender: Any) {
        let alert = UIAlertController.init(title: "Apply", message: "TODO: Add  apply form functionality on this button tap", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: nil))
        self.show(alert, sender: nil)
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
        
        //Name
        let hotel = hotels[indexPath.item]
        cell.nameLabel.text = hotel.name
        
        //Address
        cell.addressLabel.text = hotel.address
        
        //Image
        let url = URL(string: hotel.coverPhoto.url)
        cell.imageView.kf.setImage(with: url)
        
        //Rate
        if let rateText = hotel.rateText {
            cell.rateLabel.text = rateText + " ~ / month";
        }
        
        //Amenities (v1)
        var amenities = "Private Bath : " + hotel.amenities.privateBath.description
        amenities += ", Shared Kitchen : " + hotel.amenities.sharedKitchen.description
        cell.amenitiesLabel.text = amenities
        
        //Rooms (v1)
        var roomsString = ""
        for room in hotel.rooms {
            //Create a single string for all rates (for prototype v1)
            if let rate = room.rateText {
                let currentRoomString = room.name + "\n" + rate + "\n\n"
                roomsString.append(currentRoomString)
            }
        }
        cell.roomsLabel.text = roomsString
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {
            return
        }
        
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            delegate?.listViewItemDidScrollTo(indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension ListViewController {
    
    //Setters
    
    
    func refreshWithHotels(hotels : Hotels?) {
        guard let hotelsUnwrapped = hotels else {
            return
        }
        
        self.hotels = hotelsUnwrapped
        self.collectionView.reloadData()
    }
    
    //Functionality Setters
    func showHotelAtIndex(index: Int) {
        self.view.isHidden = false
        collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
    }
}

