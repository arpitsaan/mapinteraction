//
//  HotelDetailsCollectionViewCell.swift
//  anyplace
//
//  Created by Arpit Agarwal on 8/4/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit
import Kingfisher //for Image Download + Cache

class HotelDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var hotelDetailsItemModel: HotelDetailsItem? {
        didSet {
            guard let hotelDetailsItemModel = self.hotelDetailsItemModel else {
                return
            }
            
            self.nameLabel.text = hotelDetailsItemModel.name
            self.imageView.kf.setImage(with: hotelDetailsItemModel.imageURL)
            self.rateLabel.text = hotelDetailsItemModel.priceString
            self.addressLabel.text = hotelDetailsItemModel.address
            self.amenitiesLabel.text = hotelDetailsItemModel.amenitiesString
            self.roomsLabel.text = hotelDetailsItemModel.roomsString
        }
    }
}
