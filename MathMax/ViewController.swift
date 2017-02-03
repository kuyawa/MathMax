//
//  ViewController.swift
//  MathMax
//
//  Created by Mac Mini on 1/29/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var digits  = 2     // max digits to add
    var number1 = 0     // number on top
    var number2 = 0     // number on bottom
    var result  = 0     // result
    var current = 0     // current digit being added
    var oneTick = false // over 9, tick one
    
    var number1Digits : [Int] = [] // each digit for comparison
    var number2Digits : [Int] = [] // each digit for comparison
    var resultDigits  : [Int] = [] // each digit for comparison
    
    var ticks   : [UIButton] = [] // each button to assign image number
    var digits1 : [UIButton] = [] // each button to assign image number
    var digits2 : [UIButton] = [] // each button to assign image number
    var results : [UIButton] = [] // each button to assign image number
    var images  : [UIImage]  = [] // color image from 0 to 9
    var wrongs  : [UIImage]  = [] // wrong image from 0 to 9
    var blank   = UIImage(named: "blank")!
    
    @IBOutlet var imageDigits: UIButton!
    
    // Tick one
    // 0 is never used
    @IBOutlet  var tik1: UIButton!
    @IBOutlet  var tik2: UIButton!
    @IBOutlet  var tik3: UIButton!
    @IBOutlet  var tik4: UIButton!
    @IBOutlet  var tik5: UIButton!
    @IBOutlet  var tik6: UIButton!
    @IBOutlet  var tik7: UIButton!
    @IBOutlet  var tik8: UIButton!
    
    // Top row
    @IBOutlet  var top0: UIButton!
    @IBOutlet  var top1: UIButton!
    @IBOutlet  var top2: UIButton!
    @IBOutlet  var top3: UIButton!
    @IBOutlet  var top4: UIButton!
    @IBOutlet  var top5: UIButton!
    @IBOutlet  var top6: UIButton!
    @IBOutlet  var top7: UIButton!
    @IBOutlet  var top8: UIButton!
    // 9 digits only
    
    // Bottom row
    @IBOutlet  var bot0: UIButton!
    @IBOutlet  var bot1: UIButton!
    @IBOutlet  var bot2: UIButton!
    @IBOutlet  var bot3: UIButton!
    @IBOutlet  var bot4: UIButton!
    @IBOutlet  var bot5: UIButton!
    @IBOutlet  var bot6: UIButton!
    @IBOutlet  var bot7: UIButton!
    @IBOutlet  var bot8: UIButton!
    // nine gidits only

    // Result
    @IBOutlet  var res0: UIButton!
    @IBOutlet  var res1: UIButton!
    @IBOutlet  var res2: UIButton!
    @IBOutlet  var res3: UIButton!
    @IBOutlet  var res4: UIButton!
    @IBOutlet  var res5: UIButton!
    @IBOutlet  var res6: UIButton!
    @IBOutlet  var res7: UIButton!
    @IBOutlet  var res8: UIButton!
    @IBOutlet  var res9: UIButton!
    
    // Number pad
    @IBOutlet  var pad0: UIButton!
    @IBOutlet  var pad1: UIButton!
    @IBOutlet  var pad2: UIButton!
    @IBOutlet  var pad3: UIButton!
    @IBOutlet  var pad4: UIButton!
    @IBOutlet  var pad5: UIButton!
    @IBOutlet  var pad6: UIButton!
    @IBOutlet  var pad7: UIButton!
    @IBOutlet  var pad8: UIButton!
    @IBOutlet  var pad9: UIButton!
    
    @IBOutlet  var congrats: UIImageView!
    
    @IBAction func onAdd(_ sender: AnyObject) { addNumbers() }
    @IBAction func onEqual(_ sender: AnyObject) { showResults() }
    @IBAction func onLessDigits(_ sender: AnyObject) { digitsLess() }
    @IBAction func onMoreDigits(_ sender: AnyObject) { digitsMore() }
    @IBAction func onTryAgain(_ sender: AnyObject) { start() }
    @IBAction func onGuessNumber(_ sender: AnyObject) { guessNumber(sender.tag) }
    @IBAction func onTickOne(_ sender: AnyObject) { tickOne() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // // Buttons in array for digit subscript
        ticks   = [tik1, tik1, tik2, tik3, tik4, tik5, tik6, tik7, tik8] // tick 0 never used
        digits1 = [top0, top1, top2, top3, top4, top5, top6, top7, top8]
        digits2 = [bot0, bot1, bot2, bot3, bot4, bot5, bot6, bot7, bot8]
        results = [res0, res1, res2, res3, res4, res5, res6, res7, res8, res9]
        for index in 0...9 { images.append(UIImage(named: "number" + String(index))!) }
        for index in 0...9 { wrongs.append(UIImage(named: "wrong"  + String(index))!) }

        start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //---- START --------------------------------------------------
    
    func start() {
        reset()
        randomNumbers()
        updateNumbers()
    }
    
    func reset() {
        current = 0
        oneTick = false
        
        resetTicks()
        resetDigits1()
        resetDigits2()
        resetResults()
        
        congrats.isHidden = true
    }
    
    func resetTicks() {
        for index in 1...8 {
            setImageBlank(ticks[index])
        }
    }
    
    func resetDigits1() {
        for index in 0...8 {
            setImageBlank(digits1[index])
        }
    }
    
    func resetDigits2() {
        for index in 0...8 {
            setImageBlank(digits2[index])
        }
    }
    
    func resetResults() {
        for index in 0...9 {
            setImageBlank(results[index])
        }
    }
    
    func digitsMore() {
        if digits > 8 { return }
        digits += 1

        refreshCounter()
        start()
    }

    func digitsLess() {
        if digits < 2 { return }
        digits -= 1

        refreshCounter()
        start()
    }
    
    func refreshCounter() {
        setImageNumber(imageDigits, n: digits)
    }
    
    func randomNumbers() {
        // calc top and bot number according to digits: rand(1, 10^digits)
        let max = Int(NSDecimalNumber(decimal: pow(10, digits)))
        number1 = Int(arc4random_uniform(UInt32(max)))
        number2 = Int(arc4random_uniform(UInt32(max)))

        result = number1 + number2
        
        number1Digits = splitNumber(number1)
        number2Digits = splitNumber(number2)
        resultDigits  = splitNumber(result)
    }
    
    func splitNumber(_ number: Int) -> [Int] {
        return String(number).characters.reversed().map{ Int(String($0))! }  // Sorcery
    }
    
    func updateNumbers() {
        showNumber1()
        showNumber2()
    }
    
    func showNumber1() {
        let text  = String(describing: number1)
        let chars = text.characters.reversed()
        
        for (index, char) in chars.enumerated() {
            setImageNumber(digits1[index], n: Int(String(char))!)
        }
    }
    
    func showNumber2() {
        let text  = String(describing: number2)
        let chars = text.characters.reversed()
        
        for (index, char) in chars.enumerated() {
            setImageNumber(digits2[index], n: Int(String(char))!)
        }
    }
    
    func showResults() {
        let text  = String(describing: result)
        let chars = text.characters.reversed()
        
        for (index, char) in chars.enumerated() {
            setImageNumber(results[index], n: Int(String(char))!)
        }
        
        congrats.isHidden = false
    }
    
    func addNumbers() {
        if current >= digits {
            showResults()
            return
        }
        
        var n1 = 0
        var n2 = 0
        
        // Check overflow, one number may have less digits
        if current < number1Digits.count { n1 = number1Digits[current] }
        if current < number2Digits.count { n2 = number2Digits[current] }
        
        let sum = n1 + n2 + (oneTick ? 1 : 0)
        setImageNumber(results[current], n: sum>9 ? sum-10 : sum) // overflow? tick one
        current += 1
        oneTick = false

        if sum > 9 && current < digits {
            setImageNumber(ticks[current], n: 1)
            oneTick = true
        }

        if current >= digits {
            showResults()
        }
    }
    
    func guessNumber(_ number: Int) {
        //print("Guess #\(current): ", number)
        if number == resultDigits[current] {
            //print("Guessed it!")
            setImageNumber(results[current], n: number)

            // auto-tick
            var n1 = 0
            var n2 = 0
            
            // Check overflow, one number may have less digits
            if current < number1Digits.count { n1 = number1Digits[current] }
            if current < number2Digits.count { n2 = number2Digits[current] }
            
            let sum = n1 + n2 + (oneTick ? 1 : 0)
            
            if sum > 9 && current < digits {
                setImageNumber(ticks[current+1], n: 1)
                oneTick = true
            } else {
                oneTick = false
            }

            current += 1
            //if current > digits || (current == digits && digits == resultDigits.count) {
            if current == resultDigits.count {
                showResults()
            }
        } else {
            // print("Wrong, try again")
            setImageWrong(results[current], n: number)
        }
    }
    
    func tickOne() {
        if current < 1 || current >= digits { return }
        setImageNumber(ticks[current], n: 1)
    }
    
    func setImageNumber(_ button: UIButton, n number: Int) {
        button.setImage(images[number], for: UIControlState.normal)
    }
    
    func setImageWrong(_ button: UIButton, n number: Int) {
        button.setImage(wrongs[number], for: UIControlState.normal)
    }
    
    func setImageBlank(_ button: UIButton) {
        button.setImage(blank, for: UIControlState.normal)
    }

}

// End
