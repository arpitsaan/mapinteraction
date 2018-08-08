//
//  HotelDetailsCollectionViewCell.swift
//  TestMap
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
    
    var hotelDetailsModel: HotelDetailsItem? {
        didSet {
            guard let hotelDetailsModel = self.hotelDetailsModel else {
                return
            }
            
            self.nameLabel.text = hotelDetailsModel.name
            self.imageView.kf.setImage(with: hotelDetailsModel.imageURL)
            self.rateLabel.text = hotelDetailsModel.priceString
            self.addressLabel.text = hotelDetailsModel.address
            self.amenitiesLabel.text = hotelDetailsModel.amenitiesString
            self.roomsLabel.text = hotelDetailsModel.roomsString
        }
    }
}
