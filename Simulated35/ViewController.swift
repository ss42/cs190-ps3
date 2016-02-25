//
//  ViewController.swift
//  Simulated35
//
//  Created by Brian Hill github.com/brianhill on 1/25/16.
//

import UIKit

import QuartzCore

// I'm trying for a slight strobing effect just as the original HP calculators had. They
// had the strobing to conserve battery. We have the strobing solely to get an old-time feel.
// This will dim the LED segments 1/4 of the time:
let strobeMultiple = 4

let clockTicksPerAnimationInterval = 100 // Adjust to make calculator's computation speed realistic.

class ViewController: UIViewController {
    
    @IBOutlet weak var displayView: DisplayView?
    
    var displayLink: CADisplayLink?
    
    var prepares: Int = 0 // The number of prepareForVSync since the view appeared.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayLink = CADisplayLink(target:self, selector:Selector("prepareForVSync:"))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes)
        displayLink?.paused = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        prepares = 0
        displayLink?.paused = false
    }
    
    override func viewWillDisappear(animated:Bool) {
        displayLink?.paused = true
        super.viewWillDisappear(animated)
    }
    
    func prepareForVSync(displayLink: CADisplayLink) {
        let clock: Driven = Clock.sharedInstance
        for _ in 0..<clockTicksPerAnimationInterval {
            clock.drive() // should take clock from low to high
            clock.drive() // should take clock from high to low
        }
        prepares += 1
        displayView?.strobeOn = prepares % strobeMultiple != 0
        displayView?.setNeedsDisplay()
    }
    
    @IBAction func keyPressed(sender: UIButton) {
        let keyCode = KeyCode(sender.tag)
        let key = Key(rawValue: keyCode)!
        switch key {
        case Key.Key0:
            print("\(__FUNCTION__) is unimplemented for key \(key)")
        default:
            print("\(__FUNCTION__) is unimplemented for key \(key)")
        }
    }
    
    // The comment below is quoted from Apple's documentation. The handoffs between source and destination view controllers are tangled but brilliant. You have to read the documentation a few times to get it.
    
    // When you create the unwind segue in your storyboard, you specify the name of an unwind action in the view controller you want the segue to unwind to. This unwind action is invoked just before the unwind segue is performed. You can access the sourceViewController of the UIStoryboardSegue parameter to retrieve any data from the view controller that initiated the unwind segue.
    @IBAction func unwindAcknowledgements(sender: UIStoryboardSegue) {
        // Your app will crash at the downcase in the next line if you have not correctly set the type of the view controller in the acknowledgments scene.
        let gaelsViewController = sender.sourceViewController as! GaelsViewController
        // Now we show we actually can retrieve some data from the view controller that initiated the unwind segue.
        let motto = gaelsViewController.motto
        print("Success! Got motto \"\(motto)\" from the acknowledgments scene")
    }
    
    
}