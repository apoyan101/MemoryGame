//
//  ViewController.swift
//  Match Game 3
//
//  Created by Ara Apoyan on 7/30/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getCardsProtocol {
    
    @IBOutlet weak var collectionViewCell: UICollectionView!
    
    let model = CardModel()
    var cards: [Card?] = []
    
    var firstCardIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Collection view delegate and data source
        collectionViewCell.delegate = self
        collectionViewCell.dataSource = self
        
        // Set up get cards protocol delegate
        model.delegate = self
        model.getCards()
    }
    
    // MARK: - Get card Protocol Method
    func getCardsMethod(card: [Card?]) {
        self.cards = card
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if cards.count > 0 {
            return cards.count
        } else {
            print("There is no cards")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardCollectionViewCell
        if cell != nil {
            let currentCard = cards[indexPath.item]
            if currentCard != nil {
                cell!.configureCard(card: currentCard!)
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false {
            cell?.flipUp()
        } else {
            cell?.flipDown()
        }
    }
}

// MARK: - Game Logic

//func gameLogic(firstCardIndexPath: IndexPath, secondCardIndexPath: IndexPath) {
//    
//    if firstCardIndexPath == nil {
//        
//        firstCardIndexPath = indexPath
//        
//    }




