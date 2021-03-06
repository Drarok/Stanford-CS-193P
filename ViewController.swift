//
//  ViewController.swift
//  Concentration
//
//  Created by Craig Scott on 3/28/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

// In this demo, we are creating a flip card app.
// ---------------------------------------------
/*
  Create buttons in the story board on the right hand column.
  Resize and edit the object in attribute inspector in the right hand column.
 
  We are utilizing Swift's UI Controller interface
  to dynamically create functions.
  You may drag and drop GUI elements into the ViewController.
 
  On the top right, it shows two venn-diagram rings, click that to show both windows.
  One window must contain the source code, and the other the storyboard.
 
  You can drag and drop using: control and then dragging the element to the source code.
*/

import UIKit

class ViewController: UIViewController {
    
    
    //Classes in Swift get a free init, as long as vars are initialized
    //Lazy allows us to call vars & their functions
    //without the var being initialized
    //Delayed assignment almost
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    
    //Swift is extremely type-cast heavy, but also
    //type inference heavy.
    
    
    
    //CMD + click -> rename
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var gameScore: UILabel!
    //Array of UIButtons
    @IBOutlet var cardButtons: [UIButton]!
    
    
    @IBAction func NewGame(_ sender: UIButton) {
    game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)
    updateViewFromModel()
    }
    
    
    //We now have connected the second button
    //to this function.
    //We are now using array of labels in cardButtons variable
    @IBAction func TouchCard(_ sender: UIButton) {
        
        //The use of optionals:
        //--------------------
        //Put exclamation ! at end of optional to unwrap
        //Will throw error if contains nil, so we use if let
        //to use a condition to check if the optional contains an unwrappable
        //value
        if let cardNumber = cardButtons.index(of: sender)
        {
        game.chooseCard(at: cardNumber)
            
        
        updateViewFromModel()
        }
        
        else{
            print("card not in array")
        }
        
        //Sends ghost emoji to flip card function
        //flipCard(withEmoji: "👻", on: sender)
    }
    
    
    
    
    
    
    //This is using MVC design, have Concentration class & Card Class
    //Using update view from model, we only use cardButtons which is from
    //the story board. We then use the game variable to access its card
    //array. We drastically reduce code using this format.
    func updateViewFromModel(){
        let count = game.flipCount
        let score = game.score
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            
            
            if card.isFaceUp{
                button.setTitle(emoji(for:card), for: UIControlState.normal);
                
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            }
            else{
                button.setTitle("", for: UIControlState.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
            
        }
        
        flipCountLabel.text = "Flips: \(count)";
        gameScore.text = "Game Score: \(score)";
        
    }
    
    //This second function was created by copying
    //The ghost button and dragging and dropping
    //the function.
    //Unfortunately, by copying and pasting
    //The pumpkin button was also connected to the above
    //function. You must right click and delete the
    //relation between the first function and the
    //pumpkin button.
    
    //We remove this function because it is bad programming practice
    //to have to copy and paste each button function.
    //We want to create a function that is general and can take
    //multiple button classes.
    //We do this by dragging and dropping multiple buttons
    //to the same function.
    /*
    @IBAction func TouchSecondCard(_ sender: UIButton) {
        flipCount += 1;
        flipCard(withEmoji: "🎃", on: sender)
    }
    */
    
    // Flip card takes in emoji and button class.
    // It then checks the contents of button against the emoji variable
    // Depending on the emoji variable, it has associated responses
    // It will either show the ghost emoji, or it will make the button blank
    // Hence the "flip card"
    
    
    /*
    func flipCard(withEmoji emoji: String, on button: UIButton)
    {
        if(button.currentTitle == emoji)
        {
            button.setTitle("", for: UIControlState.normal);
            //Interestingly, you can set attributes to literals, click the box to change the color.
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1);
        }
        else{
            button.setTitle(emoji, for: UIControlState.normal);
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1);
        }
    }
 */
    
    
    
    
    
    func emoji(for card: Card) -> String {
        
        
        
        //Want to show why this piece of code works
        // So it initially takes a card struct, checks if there is an associated value
        // In the dictionary. If there's not, and there are still values in emojiChoices
        // Then choose a random String from emojiChoices. Remove it from the array
        // Then return the new emoji for that card.
        // Why is it returning the same card for the one directly after it?
        if game.emoji[card.identifier] == nil, game.emojiChoices.count > 0{
            let randomIndex = Int(arc4random_uniform(UInt32(game.emojiChoices.count)))
            
            game.emoji[card.identifier] = game.emojiChoices.remove(at: randomIndex)
            
        }
        
        /*
        if emoji[card.identifier] != nil{
            return emoji[card.identifier]!
        }
        else{
        return "?"
    }
    */
        
    //Short-hand way to write above
        return game.emoji[card.identifier] ?? "?"
    }

}
