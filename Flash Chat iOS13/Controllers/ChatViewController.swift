//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Chinmay Nawkar
//


import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore() // created the reference to our database.
    
    //for our struct meesage
    var messages: [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self// to trigger the delegate methods.
        
        title = K.appName
        //to hide our back button.
        navigationItem.hidesBackButton = true
        
        // registering our custom design file messageCell.nib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
        
        
        
        db.collection(K.FStore.collectionName)
        // to sort messages by order
            .order(by: K.FStore.dateField)
        //add snapShot Listener triggers realtime Updates.
            .addSnapshotListener { ( querySnapshot, error )  in
                
                self.messages = [] // empty previus msg and add fresh ones
                
                if let e = error {
                    
                    print("There was error retrieving data from Firestore. \(e)")
                }
                else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                //process of fetching data happening in the bg
                                DispatchQueue.main.async {
                                    self.tableView.reloadData() // to trigger the data source
                                    
                                    // -1 because to get the hold of last item in an arrat
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //msg body ready to send to firebase
        if let messageBody = messageTextfield.text ,let messageSender = Auth.auth().currentUser?.email {
            
            //to add the data
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField:Date().timeIntervalSince1970])  {
                (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                }
                else {
                    print("Successfully save data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
            
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // after signing out to shift user direct to welcom screen.
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        as! MessageCellTableViewCell
        cell.label.text = message.body
        // to pull out the messages array body
        
        // This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        // This is message from the another sender.
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
            
        
        
        return cell
    }
    
    
}

