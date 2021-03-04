//
//  ViewController.swift
//  Match Game 3
//
//  Created by Ara Apoyan on 7/30/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getCardsProtocol {
    
    @IBOutlet weak var collectionViewCell: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
  
    private let model = CardModel()
    private var cards: [Card] = []
    
    private var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var timeLimitSecond: Double = 20
    var milliseconds: Double = 0
    var bestTime: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Collection view delegate and data source
        self.collectionViewCell.delegate = self
        self.collectionViewCell.dataSource = self
        
        // Set up get cards protocol delegate
        self.model.delegate = self
        self.model.getCards()
        
        // Run the timer
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set up saved data
        let savedData = StateManager.loadMillData(key: StateManager.millisecondKey) as? Double
        
        // Check if saved data is not nil
        if savedData != nil {
            self.bestTime = savedData!
        }
        
        self.timeLimitSecond = setupTimer()
    }
    
    private func setupTimer() -> Double {
        Double(cards.count) * 2.5
    }
    
    // MARK: - Get card Protocol Method
    func getCardsMethod(cards: [Card]) {
        
        // Get the reference to the cards
        self.cards = cards
    }
    
    // MARK: - Timer Methods
    
    // Initialize the timer
    private func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    // Fired timer method
    @objc private func timerFired() {
        
        // Decrement the counter
        self.milliseconds += 1
        
        // Update the label
        updateTimerLabel()
        
        // Stop the timer if it's reaches the time limit
        if self.milliseconds == self.timeLimitSecond * 1000 {
            // Pause the timer
            pauseTimer()
            
            // User has lost the game
            showAnAlert(vc: self, title: "Time's Up!", messsage: "Sorry better luck next time!")
        }
    }
    
    // Start timer method
    private func startTimer() {
        runTimer()
    }
    
    // Pause timer method
    private func pauseTimer() {
        self.timer?.invalidate()
    }
    
    // Reset timer method
    private func resetTimer() {
        pauseTimer()
        self.milliseconds = 0
        runTimer()
    }
    
    // MARK: - Update UI Methods
    private func updateTimerLabel() {
        
        // Update the label text
        let seconds: Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Timer Remaning: %.2f", seconds)
        
        // Check millisecond to update label color
        if self.milliseconds != 0 {
            timerLabel.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else {
            timerLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Check if cards are not empty
        guard self.cards.count > 0 else {
            return 0
        }
        
        // Return of number of cards
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get a current card and configure it
        cardCell?.configureCard(card: self.cards[indexPath.row])
        
        // Reset the state of the cell
        if self.cards[indexPath.row].isFlipped {
            cardCell?.flipUp(speed: 0)
        } else {
            cardCell?.flipDown(speed: 0, delay: 0)
        }
        
        if self.cards[indexPath.row].isMatched {
            cardCell?.backImageView.alpha = 0
            cardCell?.frontImageView.alpha = 0
        } else {
            cardCell?.backImageView.alpha = 1
            cardCell?.frontImageView.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get a cell
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card and determinate how to flip and change it
        if self.cards[indexPath.row].isFlipped == false && self.cards[indexPath.row].isMatched == false {
            // Flip up the card
            cell?.flipUp()
            // Change the status of the card
            self.cards[indexPath.row].isFlipped = true
            
            // Check if this is the first or second card was flipped
            if self.firstFlippedCardIndex == nil {
                // This is the first card flipped over
                self.firstFlippedCardIndex = indexPath
            } else  {
                // This is the second card flipped over
                
                // Run the comparrison logic
                checkForMatch(secondFlippedCardIndex: indexPath)
            }
        }
    }
    
    // MARK: - Game Logic
    private func checkForMatch(secondFlippedCardIndex: IndexPath) {
        
        // Get the collection view cell that represente the cards
        let cardOneCell = self.collectionViewCell.cellForItem(at: self.firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = self.collectionViewCell.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the two cards object and compare them
        if self.cards[self.firstFlippedCardIndex!.row] == self.cards[secondFlippedCardIndex.row] {
            // It's match
            
            // Set the status
            self.cards[self.firstFlippedCardIndex!.row].isMatched = true
            self.cards[secondFlippedCardIndex.row].isMatched = true
            
            // Remove the cell
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was that the last pair?
            if checkForGameEnd() {
                // Pause the timer
                pauseTimer()
                
                // Convert to seconds
                let seconds = Double(self.milliseconds) / 1000.0
                
                // Compare the result and then save
                if seconds < self.bestTime ?? Double(self.timeLimitSecond) {
                    // Save timer result
                    self.bestTime = seconds
                    StateManager.saveMillData(millisecond: seconds, key: StateManager.millisecondKey)
                }
                
                // User wins
                showAnAlert(vc: self, title: "Congratulations!", messsage: "You've won the game at \(seconds) seconds! Best time is \(self.bestTime!)")
            }
        } else {
            // It's not match
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
            // Change the status of the cards
            self.cards[self.firstFlippedCardIndex!.row].isFlipped = false
            self.cards[secondFlippedCardIndex.row].isFlipped = false
        }
        
        // Reset the firstFlippedCardIndex
        firstFlippedCardIndex = nil
    }
    
    // Check the winner method
    private func checkForGameEnd() -> Bool {
        for card in self.cards {
            if card.isMatched == false {
                return false
            }
        }
        return true
    }

    // MARK: - Reset game methods
    private func resetGame() {
        
        // Get the new cards
        model.getCards()
        
        // Set the first flipped card index to nil
        self.firstFlippedCardIndex = nil
        
        // Relod the collection view with animation
        UIView.transition(with: self.collectionViewCell, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.collectionViewCell.reloadData()
        }, completion: nil)
    }

    // MARK: - Add Alert Method
    private func showAnAlert(vc: UIViewController, title: String, messsage: String) {
        
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Reset the game!", style: .default) { (completed) in
            self.resetGame()
            self.resetTimer()
        })
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 115)
        
//        switch self.cards.count {
//        case 1 ... 8:
//            return CGSize(width: (collectionView.frame.size.width - 40) / 2 - 10, height: collectionView.bounds.height / CGFloat(self.cards.count / 2) - CGFloat(self.cards.count)/2 * 10)
//        default:
//        return CGSize(width: (collectionView.frame.size.width - 40) / 3 - 10, height: collectionView.bounds.height / CGFloat(self.cards.count / 3) - CGFloat(self.cards.count)/2 * 10)
//        }
    }
    
}



