//
//  ListViewController.swift
//  TestMap
//
//  Created by Arpit Agarwal on 8/4/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import Kingfisher //for Image Download + Cache

protocol HotelDetailsViewDelegate: class {
    func listViewItemDidScrollTo(indexPath: IndexPath)
}

class HotelDetailsViewController: UIViewController {

    weak var delegate: HotelDetailsViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    //view load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitState()
    }
    
    //hotels data
    var hotels: Hotels? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //apply button action
    @IBAction func didTapApply(_ sender: Any) {
        let alert = UIAlertController.init(title: "Apply", message: "TODO: Add  apply form functionality on this button tap", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "Okay", style: .default, handler: nil))
        self.show(alert, sender: nil)
        //FIXME: Add apply functionality
    }
}

extension HotelDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Collection View Methods
    
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
        
        //----- Populate Hotel Cells ------
        
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

//-------- Interaction ---------------
extension HotelDetailsViewController {
    func setupInitState() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panUsed))
        self.view.addGestureRecognizer(panGestureRecognizer)
        self.view.frame.origin.y = self.view.frame.size.height - 150
    }
    
    func showHotelAtIndex(index: Int) {
        
        collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
    }
    
    
    func hideView(animated: Bool) {
        var hiddenFrame = self.view.frame
        hiddenFrame.origin.y = hiddenFrame.height
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.view.frame = hiddenFrame
        }
    }
    
    @objc func panUsed(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        let listViewY = self.view.frame.origin.y;
        var lvFrame = self.view.frame;
        
        if sender.state == .ended {
            let velocityThresh: CGFloat = 700
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
            
            //animate view to top/bottom edge when pan gesture ends
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.72, initialSpringVelocity: 0.1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.view.frame = lvFrame
            }, completion: nil)
        }
            
        else {
            if (listViewY + translation.y > 0) {
                
                self.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + translation.y)
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
            else {
                lvFrame.origin = .zero
                
                //snap to top
                UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.view.frame = lvFrame
                }, completion: nil)
            }
        }
    }
}
