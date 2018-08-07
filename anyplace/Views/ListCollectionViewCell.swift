//
//  ListCollectionViewCell.swift
//  TestMap
//
//  Created by Arpit Agarwal on 8/4/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    var hotel: Hotel?
    
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
}
