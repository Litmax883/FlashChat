//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by MAC on 06.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getLabel()
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        downloadMessages()
        
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let error = error {
                    print("Some problem with DB, \(error)")
                } else {
                    print("Succsessfully saved")
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error singing out: %@", signOutError)
        }
    }
    
    func downloadMessages() {
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("Error, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let message = Message(sender: sender, body: messageBody)
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getLabel() {
        var count = 1.0
        var titleUpper = ""
        self.title = ""
        let label = K.appName
        for letter in label {
            Timer.scheduledTimer(withTimeInterval: 0.1 * count, repeats: false, block: { (_) in
                titleUpper.append(letter)
                self.title = titleUpper
            })
            count += 1
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftAvatarImage.isHidden = true
            cell.avatarImage.isHidden = false
            cell.messageView.backgroundColor = UIColor.init(named: K.BrandColors.purple)
            cell.label.textColor = UIColor.init(named: K.BrandColors.lightPurple)
        } else {
            cell.leftAvatarImage.isHidden = false
            cell.avatarImage.isHidden = true
            cell.messageView.backgroundColor = UIColor.init(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor.init(named: K.BrandColors.purple)
        }
        return cell
    }
    
    
}
