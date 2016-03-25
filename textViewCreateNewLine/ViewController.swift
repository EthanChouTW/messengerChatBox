//
//  ViewController.swift
//  textViewCreateNewLine
//
//  Created by pp1285 on 2016/3/25.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBAction func pressedBtn(sender: AnyObject) {
        print("you press button")
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //register notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // add tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action:#selector(ViewController.HideTap))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    // call when keyboard shows up
    func keyboardWillShow(noti:NSNotification) {
        print("keyboard show")
        self.moveTextView(true, noti: noti)
    }
    
    // call when keyboard shows up
    func keyboardWillHide(noti:NSNotification) {
        print("keyboard down")
        self.moveTextView(false, noti: noti)
        
    }
    
    // move up or down
    func moveTextView(up:Bool,noti:NSNotification ) {
        
        UIView.beginAnimations("enen", context: nil)
        
        UIView.setAnimationDuration((noti.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue)! )
        
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: noti.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!)
        
        let kbheight = (noti.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size.height
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.bottomHeight.constant = up ? kbheight! : 0
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
        
        
    }
    
    
    // action when tap
    func HideTap() {
        self.view.endEditing(true)
    }
    
    //get size of string
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
                                                         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                         attributes: [NSFontAttributeName: font],
                                                         context: nil).size
    }
    
    // call before typing
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        var textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset))
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
        
        let boundingRect = sizeOfString(newText, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight;
        
        if numberOfLines >= 3 {
            inputTextView.scrollEnabled = true
            return true
        }
        inputTextView.scrollEnabled = false
        return numberOfLines <= 3;
    }
    
    
}

