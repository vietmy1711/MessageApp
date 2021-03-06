//
//  MessageViewController.swift
//  MessageApp
//
//  Created by MM on 6/25/20.
//  Copyright © 2020 MM. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var txvInput: UITextView!
    
    var imagePicker = UIImagePickerController()
    
    var messages: [Message] = [
        Message(sender: 1, text: "", image: UIImage(named: "img-1")),
        Message(sender: 1, text: "Alo hehe", image: nil),
        Message(sender: 0, text: "Zô zô", image: nil),
        Message(sender: 1, text: "Dzâu xâu", image: nil),
        Message(sender: 1, text: "Em iu", image: nil),
        Message(sender: 0, text: "Lè lé lè lé lè", image: nil),
        Message(sender: 0, text: "", image: UIImage(named: "img-2")),
        Message(sender: 0, text: "Zô zô", image: nil),
        Message(sender: 1, text: "Alo alo huhu", image: nil),
        Message(sender: 1, text: "Alo alo", image: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SenderChatCell", bundle: nil), forCellReuseIdentifier: "SenderChatCell")
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        txvInput.delegate = self
        setupUI()
        
        handleKeyboard()
        scrollToBottom()
        btnSend.isHidden = true
    }
    
    func setupUI() {
        txvInput.layer.cornerRadius = 25
        txvInput.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        txvInput.text = "Enter message"
        txvInput.textColor = UIColor.lightGray
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func handleKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notication:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notication:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notication:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChange(notication: Notification) {
        guard let keyboard = (notication.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notication.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -keyboard.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        view.endEditing(true)
        txvInput.text = txvInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if txvInput.text != "" {
            let newMessage = Message(sender: 0, text: txvInput.text!, image: nil)
            messages.append(newMessage)
            tableView.reloadData()
            scrollToBottom()
        }
        txvInput.text = "Enter message"
        txvInput.textColor = UIColor.lightGray
    }
    
    @IBAction func imgButtonClicked(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension MessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        btnSend.isHidden = false
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
        if textView.text == "" {
            btnSend.isHidden = true
        }
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].sender == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.configWithMessage(message: messages[indexPath.row])
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatCell", for: indexPath) as! SenderChatCell
        if indexPath.row != 0 {
            if messages[indexPath.row].sender == messages[indexPath.row - 1].sender {
                cell.configWithMessage(message: messages[indexPath.row], isSuccessive: true)
            }
            cell.configWithMessage(message: messages[indexPath.row], isSuccessive: false)
        }
        else {
            cell.configWithMessage(message: messages[indexPath.row], isSuccessive: false)
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension MessageViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let newMessage = Message(sender: 0, text: "", image: chosenImage)
        messages.append(newMessage)
        
        tableView.reloadData()
        scrollToBottom()
        self.dismiss(animated: true)
    }
}
