//
//  ChatVC.swift
//  POPX
//
//  Created by Adham Albanna on 8/3/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit    
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var ListMessages=Array<Message>()
    @IBOutlet weak var massegeToSendTF: UITextField!
    let userName = Auth.auth().currentUser!
    let ref = Database.database().reference()
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var uiViewSendChat: UIView!
    
    var userUid = ""
    var chatId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        getLastUser()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getChat() {
        self.ref.child("msg").child("\(userUid)_\(userName.uid)").observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if dataSnapshot.exists() {
                self.chatId = "\(self.userUid)_\(self.userName.uid)"
            }
            
            self.LoadMessages()
        }) { (error) in
            self.LoadMessages()
        }
    }

//    func getMessages(messageKey: String){
//        let li = Database.database().reference(withPath: "msg").child("\(userName.uid)_\(userUid)").observe(.value) { (dataSnapshot) in
//
//            guard dataSnapshot.exists(), dataSnapshot.children.allObjects.count > 0 else {
//
//                return
//            }
//        }
//    }
    
    func getLastUser() {
        getUser { (userUid) in
            guard let userUid = userUid else{
                return
            }

            self.userUid = userUid
            self.chatId = "\(self.userName.uid)_\(userUid)"
            self.getChat()
        }
    }
    
    func getUser(completion: ((_ userUid: String?) -> Void)? = nil){
        Database.database().reference(withPath: "online").observeSingleEvent(of: .value, with: { (snapshot) in
            snapshot.children.forEach { (objct) in
                let data = objct as! DataSnapshot
                let key = data.key
                print("getUser key: \(key)")
                if self.userName.uid != key {
                    print(key)
                    completion?(key)
                }
            }
        }) { (error) in
            print("getUser error: \(error.localizedDescription)")
            completion?(nil)
        }
    }
    
    
//    func getUser(completion: ((_ userUid: String?) -> Void)? = nil){
//        Database.database().reference(withPath: "online").observeSingleEvent(of: .value) { (dsn) in
//            self.keys.removeAll()
//            dsn.children.forEach { (objct) in
//                let data = objct as! DataSnapshot
//                let key =  data.key
//                if self.userName.uid != key {
//                    print(key)
//                    self.keys.append(key)
//                    completion?(key)
//                    return
//                }
//            }
//            print(self.keys[0])
//        }
//    }
    
    
    
    @IBAction func btnSendChat(_ sender: Any) {
        if chatId.isEmpty{
            getLastUser()
            return
        }
        if massegeToSendTF.text == ""{
            print("text field is embty")
        }else {
            
            let msg = ["userName":userName.email ?? "","date":ServerValue.timestamp(),"text":massegeToSendTF.text ?? ""] as [String : Any]
            let firebaseMsg = self.ref.child("msg").child(self.chatId).childByAutoId()
            firebaseMsg.setValue(msg)
            self.massegeToSendTF.text = ""
        }
    }
    
    func AddSnap(ImagPath:String){
        let msg=[
            "UserName":userName.email ?? "user",
            "text":massegeToSendTF.text ?? "no-message",
            "postDate": ServerValue.timestamp(),
            "ImagePath":ImagPath
            ] as [String:Any]
        let FirebaseMessage=self.ref.child("msg").childByAutoId()
        FirebaseMessage.setValue(msg)
        massegeToSendTF.text=""
    }
    
    
    func LoadMessages(){
        guard !chatId.isEmpty else {
            getLastUser()
            return
        }
        self.ref.child("msg").child(self.chatId).queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            self.ListMessages.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? [String:AnyObject]{
                        self.setMessage(msgId: snap.key, msgData: postDict)
                        print(postDict["text"] ?? "no msg")
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.scrollToBottom()
        })
    }
    
    func setMessage(msgId:String,msgData:[String:AnyObject]){
        var text:String!
        var userName:String!
        var postDate:String!
        var imagePath:String!
        if let userName1 = msgData["userName"] as? String {
            userName=userName1
        } else {
            userName="no-data"
        }
        if let postDate1 = msgData["date"] as? String {
            postDate=postDate1
        }else{
            postDate="no-data"
        }
        if let text1 = msgData["text"] as? String{
            text=text1
        }
        if let imagePath1 = msgData["imagePath"] as? String{
            imagePath=imagePath1
        }else{
            imagePath="no-data"
        }
        self.ListMessages.append(Message(text: text, userName: userName, postDate: postDate, imagePath: imagePath))
        
    }
    
    
    @IBAction func btnLoadImages(_ sender: Any) {
        presentPhotoActionSheet()
        
    }
}



extension ChatVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListMessages.count
    }
    
    func tableView(_ tableViw: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = ListMessages[indexPath.row]
        let identifire = (message.userName == self.userName.email) ? "cellText2" : "cellText"
        let cell:ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifire,for: indexPath) as! ChatTableViewCell
        cell.setText(msg: message.text)
        //cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
                                                
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentPhotoPicker()
                                                
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) != nil else {
            return
        }
        
        //self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

