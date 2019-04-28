//
//  ViewController.swift
//  Memo
//
//  Created by Annie Do on 4/26/19.
//  Copyright © 2019 Annie Do. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, MemoViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    //selected index when transitioning (-1 as sentinel value)
    var selectedIndex = -1

    //an array of dictionaaries
    //keys = "title", "body"
    var arrMemo = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //read in the saved value. use "as?" to convert "AnyObject"
        //this is in an if-block so no "nil found" errors crash the app
        //this is known as downcasting
        if let newMemo = UserDefaults.standard.array(forKey: "memo") as? [[String:String]] {
            //set the instance variable to the newNotes variable
            arrMemo = newMemo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the desired # of elements. In this case, 5 return 5
        return arrMemo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //grab the "default cell", using the identifier we set up in the Storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        //set the text to a test value to make sure it's working cell.textLabel!.text = "Test Value"
        cell.textLabel!.text = arrMemo[indexPath.row]["title"]
        
        //return the newly-mofified cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set the selected index before segue
        self.selectedIndex = indexPath.row
        
        //push the editor view using the predefined segue
        performSegue(withIdentifier: "showEditorSegue", sender: nil)
        
    }
    
    @IBAction func newMemo() {
        //new dictionary with 2 keys and test values for both
        let newDict = ["title" : "",
                       "body" : ""]
        
        //add the dictionary to the front (or top) of the array
        arrMemo.insert(newDict, at: 0)
        
        //set the selected index to the most recently added item
        self.selectedIndex = 0
        
        //reload the table ( refresh the view)
        self.tableView.reloadData()
        
        //save memo to the phone
        saveMemoArray()
        
        //push the editor view using te predefined segue
        performSegue(withIdentifier: "showEditorSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //grab the view controller we are foing to transition to
        let memoEditorVC = segue.destination as! MemoViewController
        
        //set the title of the navigation bar to the selectedIndex's title
        memoEditorVC.navigationItem.title = arrMemo[self.selectedIndex]["title"]
        
        //set the body of the view controller to the selectedIndex's body
        memoEditorVC.strBodyText = arrMemo[self.selectedIndex]["body"]
        
        //set the delegate to "self", so the method gets called here
        memoEditorVC.delegate = self
        
    }
    
    func didUpdateMemoWithTitle(newTitle: String, andBody newBody:String) {
        
        //update the respective values
        self.arrMemo[self.selectedIndex]["title"] = newTitle
        self.arrMemo[self.selectedIndex]["body"] = newBody
        
        //refresh the view
        self.tableView.reloadData()
        
        //save the memo to the phone
        saveMemoArray()
    }
    
    func saveMemoArray() {
        //save the newly updated array
        UserDefaults.standard.set(arrMemo, forKey: "memo")
        UserDefaults.standard.synchronize()
    }
    
}

