
protocol getCardsProtocol {
    func getCardsMethod(cards: [Card])
}

import Foundation


class CardModel {
    
    var delegate: getCardsProtocol?
    
    // Declare an empty array of Card type
    var cardsArray: [Card] = []
    let cardsCount: Int = 8
    
    // Get the cards
    func getCards() {
        
        // Reset cards array
        if self.cardsArray.count != 0 {
            // Remove all cards from cards array
            self.cardsArray.removeAll()
        }
        
        // Randomly generate 8 pairs of cards
        while self.cardsArray.count < self.cardsCount {
            // Generate a random number
            let randomElement = Int.random(in: 1...13)
            // Create an instance of Card struct
            let card = Card(imageName: "card\(randomElement)")
            // check if cardsArray contains of card
            if !self.cardsArray.contains(card) {
                // Append card to cardsArray
                self.cardsArray.append(card)
            }
        }
        // Make a duplicate of cards
        self.cardsArray += cardsArray
        
        // Shufle the cards
        self.cardsArray.shuffle()
       
        // Notify the delegate of the cards
        self.delegate?.getCardsMethod(cards: self.cardsArray)
    }
}
