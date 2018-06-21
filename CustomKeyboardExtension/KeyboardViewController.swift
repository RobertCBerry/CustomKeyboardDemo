//
//  KeyboardViewController.swift
//  CustomKeyboardExtension
//
//  Created by Robert Berry on 6/21/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    // MARK: Properties

    @IBOutlet var nextKeyboardButton: UIButton!
    
    // Property determines if the caps lock is on.
    
    var capsLockOn = false
    
    // Rows for keyboard displaying numbers and letters.
    
    let numbersAndLettersKeyboard = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                                     ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                                     ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                                     ["Z", "X", "C", "V", "B", "N", "M"],
                                     ["↑", "⇔", "Space", "←", "↵", "1/2"]]
    
    // Rows for keyboard displaying symbols.
    
    let symbolsKeyboard = [["/", "-", ":", ";", "(", ")", "%", "^"],
                                   ["!", ".", "?", "@", "#", "$", "&", "*", "+", "=",],
                                   ["2/2", "⇔", "Space", "←", "↵"]]
    
    // Creates instances of stack views.
    
    var numbersAndLettersKeyboardStackView: UIStackView!
    
    var symbolsKeyboardStackView: UIStackView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Sets the view's background color to gray.
        
        view.backgroundColor = .gray
        
        numbersAndLettersKeyboardStackView = createKeyboardRowsStackView(buttonsRow: numbersAndLettersKeyboard)
        
        
        symbolsKeyboardStackView = createKeyboardRowsStackView(buttonsRow: symbolsKeyboard)
        
        // Hides the symbols keyboard upon app launch.
        
        symbolsKeyboardStackView.isHidden = true
    }
    
    // MARK: Action Methods
    
    // Method takes an array of strings, creates a UIButton for each of them, and then adds all the buttons to a horizontal stack view. Each horizontal stack view represents a row of keys in our keyboard.
    
    func createButtonsRowStackView(titles: [String]) -> UIStackView {
        
        // Creates instance of UIStackView.
        
        let stackView = UIStackView()
        
        // Provides for the distribution of the arranged views along the stack view's access.
        
        stackView.distribution = .equalSpacing
        
        stackView.alignment = .center
        
        // Provides spacing in points between the edges of the stack view's views.
        
        stackView.spacing = 1
        
        for title in titles {
            
            // Creates custom button.
            
            let button = UIButton(type: .custom)
            
            // Sets title for each button instance.
            
            button.setTitle(title, for: .normal)
            
            // Sets button title color.
            
            button.setTitleColor(.white, for: .normal)
            
            // Sets button background color.
            
            button.backgroundColor = .lightGray
            
            // Sets button height.
            
            button.heightAnchor.constraint(equalToConstant: 42).isActive = true
            
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9)
            
            // Rounds corners of the button.
            
            button.layer.cornerRadius = 3
            
            button.addTarget(self, action: #selector(KeyboardViewController.tappedButton(button:)), for: .touchUpInside)
            
            // Adds button item to the stack view.
            
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    // Method creates vertical stack view that will contain rows of keyboard buttons.
    
    func createKeyboardRowsStackView(buttonsRow: [[String]]) -> UIStackView {
        
        var keyboardRowStackViews = [UIStackView]()
        
        for title in buttonsRow {
           
            let newStackView = createButtonsRowStackView(titles: title)
            
            keyboardRowStackViews.append(newStackView)
        }
       
        let allRowsStackView = UIStackView(arrangedSubviews: keyboardRowStackViews)
        
        // Sets stack view to be a vertical stack view.
        
        allRowsStackView.axis = .vertical
       
        allRowsStackView.alignment = .center
       
        allRowsStackView.spacing = 1
        
        // Adds the allRowsStackView to the view.
       
        view.addSubview(allRowsStackView)
        
        // Sets constraints for the allRowsStackView.
        
        allRowsStackView.translatesAutoresizingMaskIntoConstraints = false
       
        allRowsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        allRowsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
        
        return allRowsStackView
    }
    
    // Method handles key presses on all of the keys.
    
    @objc func tappedButton(button: UIButton) {
        
        // Retrieves the title of the button that was tapped.
        
        let keyTitle = button.titleLabel!.text
        
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        // Switch based on which keyTitle is selected.
        
        switch keyTitle! {
        
        case "↑":
            
            // Conditional determines if the caps lock key is on or not.
            
            if capsLockOn {
                
                button.backgroundColor = .lightGray
                
                capsLockOn = false
            
            } else {
                
                button.backgroundColor = UIColor(red: 0.5922, green: 0.5922, blue: 0.5922, alpha: 1.0)
                
                capsLockOn = true
            }
            
        case "⇔":
            
            // Switches to the next keyboard in the list of user enabled keyboards.
            
            advanceToNextInputMode()
            
        case "Space":
            
            // Inserts character into the displayed text.
            
            proxy.insertText(" ")
            
        case "←":
            
            // Deletes a character from the displayed text.
            
            proxy.deleteBackward()
            
        case "↵":
            
            // Moves cursor to the next line of the input field.
            
            proxy.insertText("\n")
            
        // When tapped the numbers and letters keyboard is hidden and the symbols keyboard appears.
            
        case "1/2":
            
            numbersAndLettersKeyboardStackView.isHidden = true
            
            symbolsKeyboardStackView.isHidden = false
            
        // When tapped the numbers and letters keyboard appears and the symbols keyboard is hidden.
            
        case "2/2":
            
            numbersAndLettersKeyboardStackView.isHidden = false
            
            symbolsKeyboardStackView.isHidden = true
            
        // Inserts key tapped into text field.
       
        default:
            
            let textToInset: String
            
            if capsLockOn {
                
                textToInset = keyTitle!.uppercased()
            
            } else {
                
                textToInset = keyTitle!.lowercased()
            }
            
            proxy.insertText(textToInset)
        }
    }
}
