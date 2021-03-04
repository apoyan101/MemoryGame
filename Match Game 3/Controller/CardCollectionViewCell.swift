//
//  CardCollectionViewCell.swift
//  Match Game 3
//
//  Created by Ara Apoyan on 7/30/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
 
    func configureCard(card: Card) {
        
        // Set the front image view to the image that representes the card
        self.frontImageView.image = UIImage(named: card.imageName)
    }
    
    func flipUp(speed: TimeInterval = 0.3) {
        
        // Flip up animation
        UIView.transition(from: self.backImageView, to: self.frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            // Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
    }
    
    func remove() {
        
        self.backImageView.alpha = 0
        
        // Make the image view invisible
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)

    }
    
    func restore() {
        
        self.backImageView.alpha = 1
        
        // Make the image view visible
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 1
        }, completion: nil)
    }
    
}





