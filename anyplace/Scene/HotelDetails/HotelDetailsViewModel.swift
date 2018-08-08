//
//  HotelDetailsViewModel.swift
//  anyplace
//
//  Created by Arpit Agarwal on 08/08/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

import UIKit

class HotelDetailsViewModel: NSObject {

    enum Offset: CGFloat {
        case initial = 150.0
    }
    
    var listViewY: CGFloat = UIScreen.main.bounds.height - Offset.initial.rawValue
    var listViewTranslation: CGPoint?
    var listViewVelocity: CGPoint?
    var listViewFrame: CGRect?
    
    lazy var itemSize: CGSize = self.getItemSize()

    func setDefaultFrame(_ handler: @escaping (_: CGRect) -> ()) {
        guard var frame = self.listViewFrame else {
            return
        }
        frame.origin.y = frame.size.height - Offset.initial.rawValue
        self.listViewFrame = frame
        handler(frame)
    }
    
    func updateViewFrame(sender: UIPanGestureRecognizer, _ handler: @escaping (_: CGRect) -> ()) {
        guard let translation = self.listViewTranslation, let velocity = self.listViewVelocity, var frame = self.listViewFrame else {
            return
        }
        
        if sender.state == .ended {
            let velocityThreshold: CGFloat = 700.0
            let showHeight = frame.size.height - Offset.initial.rawValue
            let heightThreshold: CGFloat = frame.size.height / 2
            
            if (velocity.y < -velocityThreshold) {
                //swiped top
                frame.origin.y = 0
            }
            else if (velocity.y > velocityThreshold) {
                //swiped down
                frame.origin.y = frame.size.height - Offset.initial.rawValue
            }
            else {
                if (self.listViewY < heightThreshold) {
                    //top snap
                    frame.origin.y = 0
                }
                else if (self.listViewY >= heightThreshold) {
                    //bottom snap
                    frame.origin.y = showHeight
                }
            }
            
            self.listViewFrame = frame
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.72, initialSpringVelocity: 0.1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                handler(frame)
            }, completion: nil)
        }
        else {
            if (self.listViewY + translation.y > 0) {
                frame.origin.y = frame.origin.y + translation.y
                self.listViewFrame = frame
                sender.setTranslation(CGPoint.zero, in: sender.view)
                handler(frame)
            }
            else {
                frame.origin = .zero
                self.listViewFrame = frame
                UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    handler(frame)
                }, completion: nil)
            }
        }
    }
    
    func getItemSize() -> CGSize {
        if #available(iOS 11.0, *) {
            //adjust for safe area
            let window = UIApplication.shared.keyWindow
            if let topPadding = window?.safeAreaInsets.top,
                let bottomPadding = window?.safeAreaInsets.bottom {
                return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - topPadding - bottomPadding)
            }
        }
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}
