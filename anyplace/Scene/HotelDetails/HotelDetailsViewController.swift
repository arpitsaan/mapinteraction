//
//  HotelDetailsViewController.swift
//  anyplace
//
//  Created by Arpit Agarwal on 8/4/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit

protocol HotelDetailsViewDelegate: class {
    func listViewItemDidScrollTo(indexPath: IndexPath)
}

class HotelDetailsViewController: UIViewController {

    weak var delegate: HotelDetailsViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    //view model
    private var hotelDetailsViewModel = HotelDetailsViewModel()
    
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
    }
}

//--------------------------
// Collection View Methods
//--------------------------
extension HotelDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let hotels = self.hotels else {
            return 0
        }
        
        return hotels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelDetailsCollectionViewCell", for: indexPath) as! HotelDetailsCollectionViewCell
        cell.nameLabel.text = "\(indexPath.item)"
        
        guard let hotels = self.hotels else {
            return cell
        }
        
        //----- Populate Hotel Detail Cells ------
        let hotel = hotels[indexPath.item]
        let hotelDetailsItemModel = HotelDetailsItem(with: hotel)
        cell.hotelDetailsItemModel = hotelDetailsItemModel

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return hotelDetailsViewModel.getItemSize()
    }
    
    //delegate event when scrolling ends
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {
            return
        }
        
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            delegate?.listViewItemDidScrollTo(indexPath: indexPath)
        }
    }

}
//---------------
// Interactions
//---------------
extension HotelDetailsViewController {
    
    func setupInitState() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panUsed))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        self.hotelDetailsViewModel.listViewFrame = self.view.frame
        self.hotelDetailsViewModel.setDefaultFrame { (frame) in
            self.view.frame = frame
        }
    }
    
    func showHotelAtIndex(index: Int, animated: Bool) {
        if self.view.isHidden == true {
            showView(animated: animated)
        }
        
        collectionView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
    }
    
    func showView(animated: Bool) {
        var showFrame = self.view.frame
        showFrame.origin.y = self.hotelDetailsViewModel.listViewY
        
        var hideFrame = showFrame
        hideFrame.origin.y = hideFrame.height
        self.view.frame = hideFrame
        
        self.view.isHidden = false
        
        self.view.alpha = 0
        UIView.animate(withDuration: animated ? 0.1 : 0, animations: {
            self.view.frame = showFrame
            self.view.alpha = 1
        }, completion: { (finished: Bool) in
        })
    }
    
    
    func hideView(animated: Bool) {
        var hiddenFrame = self.view.frame
        hiddenFrame.origin.y = hiddenFrame.height
        self.view.alpha = 1
        
        UIView.animate(withDuration: animated ? 0.2 : 0, animations: {
            self.view.frame = hiddenFrame
            self.view.alpha = 0
        }, completion: { (finished: Bool) in
            self.view.isHidden = true
            self.view.alpha = 1
        })
    }

    //Pan Gesture Interaction
    @objc func panUsed(sender: UIPanGestureRecognizer) {
        
        self.hotelDetailsViewModel.listViewTranslation = sender.translation(in: self.view)
        self.hotelDetailsViewModel.listViewVelocity = sender.velocity(in: self.view)
        self.hotelDetailsViewModel.listViewY = self.view.frame.origin.y;
        self.hotelDetailsViewModel.listViewFrame = self.view.frame;
        
        self.hotelDetailsViewModel.updateViewFrame(sender: sender) { (frame) in
            self.view.frame = frame
        }
    }
}
