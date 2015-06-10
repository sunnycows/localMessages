//
//  ViewController.swift
//  Messaging
//
//  Created by Oleh Sannikov on 10.06.15.
//  Copyright (c) 2015 Oleh Sannikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    let kTextFieldBottomOffset: CGFloat = 4
    let kMessageCellId = "messageCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldOffset: NSLayoutConstraint!
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: kMessageCellId)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            if let rate = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval {
                UIView.animateWithDuration(rate, animations: {
                    let size = value.CGRectValue().size
                    self.textFieldOffset.constant = self.kTextFieldBottomOffset + size.height
                })
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let rate = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval {
            UIView.animateWithDuration(rate, animations: {
                self.textFieldOffset.constant = self.kTextFieldBottomOffset
            })
        }
    }

    // MARK: Actions
    @IBAction func sendMessage(sender: AnyObject) {
        if !textField.text.isEmpty {
            DataManager.sharedManager.addMessage(textField.text)
            textField.text = nil
            
            messages = DataManager.sharedManager.messages
            tableView.reloadData()
        }
    }

    @IBAction func hideKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    // MARK: TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !textField.text.isEmpty {
            sendMessage(textField)
        }
        return true
    }
    
    // TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kMessageCellId) as! UITableViewCell
        
        cell.textLabel?.text = messages?[indexPath.row].text
        
        return cell
    }
}

