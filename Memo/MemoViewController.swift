//
//  MemoViewController.swift
//  Memo
//
//  Created by Annie Do on 4/27/19.
//  Copyright © 2019 Annie Do. All rights reserved.
//

import UIKit
import CoreData

//the delegate pattern, so we can update the table view's selected item
protocol MemoViewDelegate {
    //the name of the function that will be implemented
    func didUpdateMemoWithTitle(newTitle : String, andBody newBody : String)
}

class MemoViewController: UIViewController, UITextViewDelegate {
    //a variable to hold the delegate, so we can update the tableview
    var delegate : MemoViewDelegate?
    //a string variable to hold the body text
    var strBodyText: String!
    
    @IBOutlet weak var txtBody: UITextView!
    @IBOutlet weak var btnDoneEditing: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //set the body's text to the intermitent string
        self.txtBody.text = self.strBodyText
        
        //makes the keyboard appear immediately
        self.txtBody.becomeFirstResponder()
        
        //allows UITextView methods to be called
        self.txtBody.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.registerKeyboardNotifications()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //tell the main view controller that we're going to update the selected item
        //but only if the delegate is NOT nil
        if self.delegate != nil {
            self.delegate!.didUpdateMemoWithTitle(
                newTitle: self.navigationItem.title!, andBody: self.txtBody.text)
        }
    }
    
    
    @IBAction func doneEditingBody() {
        //hides the keyboard
        self.txtBody.resignFirstResponder()
        
        //makes the button invisible
        //self.btnDoneEditing.tintColor = UIColor.clear
        
        //tell the main view controller that we're going to update the selected item
        //but only if the delegate is NOT nil
        if self.delegate != nil {
            self.delegate!.didUpdateMemoWithTitle( newTitle: self.navigationItem.title!, andBody: self.txtBody.text)
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        //sets the color of the Done button to the default blue
//        //it's not a pre-defined value like clearColor, so we give it the exact RGB values
//        self.btnDoneEditing.tintColor = UIColor(red: 0, green:
//            122.0/255.0, blue: 1, alpha: 1)
//    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        //separate the body into multiple sections
        let components = self.txtBody.text.components(separatedBy:"\n")

        //reset the title to blank (in case there are no components with valid text)
        self.navigationItem.title = ""

        //loop through each item in the components array
        for item in components {
            //if the number of letters in the item is greater than 0...
            if item.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) != nil {

                //then set the title to the item itself, and break out of the for loop
                    self.navigationItem.title = item
                break
            }
        }
    }

//    func registerKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(MemoViewController.keyboardDidShow(notification:)), name:
//            UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector:
//            #selector(MemoViewController.keyboardWillHide(notification:)), name:
//            UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    func unregisterKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    @objc func keyboardDidShow(notification: NSNotification) {
//        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
//        let keyboardSize = keyboardInfo.cgRectValue.size
//
//        // Get the existing contentInset for the scrollView and set the bottom property to be the height of the keyboard
//        var contentInset = self.scrollView.contentInset
//        contentInset.bottom = keyboardSize.height
//
//        self.scrollView.contentInset = contentInset
//        self.scrollView.scrollIndicatorInsets = contentInset
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        var contentInset = self.scrollView.contentInset
//        contentInset.bottom = 0
//
//        self.scrollView.contentInset = contentInset
//        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
