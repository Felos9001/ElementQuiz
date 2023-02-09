//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Felipe Solorzano on 2/7/23.
//

import UIKit

// Declaring enums Mode and State.
enum Mode {
    case Flashcards
    case quiz
}
enum State {
    case question
    case answer
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    
       
    //Declaring variables within the UI.
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    //Declaring the variables used in ViewController.
       
    var state: State = .question
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    var currentElementIndex = 0
    var answerIsCorrect = false
    var correctAnswerCount = 0
    var mode: Mode = .Flashcards {
        didSet {
            switch mode {
            case .Flashcards:
                setUpFlashCards()
            case .quiz:
                setUpQuiz()
            }
            updateUI()
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // additional setup after loading the view.
        mode = .Flashcards
    }
        
    
    //Updates the app's UI in Flashcard mode.
    func updateFlashcardUI(elementName: String) {
        //text field and keyboard
        textField.isHidden = true
        textField.resignFirstResponder()
        
        //Answer label
        if state == .answer {
            answerLabel.text = elementName
        } else {
            answerLabel.text = "?"
        }
        
        //Segmented control
        modeSelector.selectedSegmentIndex = 0
        
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("next element", for: .normal)
    }
    
    //updates the app's UI in quiz mode
    func updatesQuizUI(elementName: String) {
        //Text field and keyboard
        textField.isHidden = false
        switch state {
        case .question:
            textField.text = ""
            textField.resignFirstResponder()
        case .answer:
            textField.resignFirstResponder()
               case .score:
                   textField.isHidden = true
                   textField.resignFirstResponder()
        }
        
        //Answer label
        switch state {
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect == true {
                answerLabel.text = "Correct!"
            } else {
                answerLabel.text = "❌"
            }
        case .score:
            answerLabel.text = ""
            print("Your score is \(correctAnswerCount) out of \(elementList.count).")
        }
        
        //Score display
        if state == .score {
            displayScoreAlert()
        }
        
        //Segmented control
        modeSelector.selectedSegmentIndex = 0
        
        //Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show Score", for: .normal)
        } else {
            nextButton.setTitle("next question", for: .normal)
        }
        
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
    }
    
    //Updates the app's UI based on the mode and state
    func updateUI() {
        //Shared code: updating the image
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named:elementName)
        imageView.image = image
        
        switch mode {
        case.Flashcards: updateFlashcardUI(elementName: elementName)
        case.quiz: updatesQuizUI(elementName: elementName)
        }
    }
    
    //Function for the "Answer Button" button.
    @IBAction func ShowAnswer(_ sender: Any) {
        state = .answer
        updateUI()
    }
    
    //Function for the "Next Element" button.
    @IBAction func Next(_ sender: Any) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    
    @IBAction func switchModes(_ sender: Any) {
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .Flashcards
        } else {
            mode = .quiz
        }
    }
    
    //Shows an IOS alert with the result of the users quiz score
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Your score is \(correctAnswerCount) out of \(elementList.count)", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .Flashcards
    }

    //Runs after the user hits the return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Get the text from the text field
        let textFieldContents = textField.text!
    
        //Determine whether the user answered correctly and update the quiz accoridingly state
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
        answerIsCorrect = true
        correctAnswerCount += 1
        } else {
        answerIsCorrect = false
        }
        
            if answerIsCorrect {
                print("Correct!")
            } else {
                print("❌")
            }
        
        //the app should now display the answer to the user
        state = .answer
        
        updateUI()
        
        return true
    }
    
    //Sets up a new flash card session
    func setUpFlashCards() {
        state = .question
        currentElementIndex = 0
        elementList = fixedElementList
    }
    
    //sets up a new quiz session
    func setUpQuiz() {
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }
}
